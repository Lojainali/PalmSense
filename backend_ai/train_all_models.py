# ===================================================================
# PalmSense - Multi-Model Training & Ensemble (Google Colab)
# ===================================================================
# Models: MobileNetV3-Large, ResNet-50, + Ensemble with EfficientNet-B0
# Run each section as a separate Colab cell (marked with # %% CELL)
# ===================================================================

# %% CELL 1 - Mount Google Drive & Setup
from google.colab import drive
drive.mount('/content/drive')

import os
import time
import copy
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from collections import Counter

import torch
import torch.nn as nn
import torch.optim as optim
from torch.amp import autocast, GradScaler
from torchvision import transforms, models
from torch.utils.data import DataLoader
from torchvision.datasets import ImageFolder
from sklearn.metrics import classification_report, confusion_matrix

device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
print(f"🔧 Device: {device}")
if device.type == 'cuda':
    print(f"   GPU: {torch.cuda.get_device_name(0)}")

# %% CELL 2 - Dataset Setup (Same as EfficientNet training)
DATASET_DIR = '/content/drive/MyDrive/PalmSense_Dataset'  # ← UPDATE if your path is different
SAVE_DIR = '/content/drive/MyDrive'

# If your dataset is in a different location, update DATASET_DIR above.
# The folder structure should be:
#   PalmSense_Dataset/
#     train/
#       4. Black Scorch/
#       6. Fusarium Wilt/
#       7. Rachis Blight/
#       Healthy sample/
#       Leaf spots/
#     val/
#       (same subfolders)

# Data transforms (same as EfficientNet training for fair comparison)
train_transforms = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.RandomHorizontalFlip(),
    transforms.RandomVerticalFlip(),
    transforms.RandomRotation(20),
    transforms.ColorJitter(brightness=0.2, contrast=0.2, saturation=0.2),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225]),
])

val_transforms = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225]),
])

train_dataset = ImageFolder(os.path.join(DATASET_DIR, 'train'), transform=train_transforms)
val_dataset = ImageFolder(os.path.join(DATASET_DIR, 'val'), transform=val_transforms)

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True, num_workers=2, pin_memory=True)
val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False, num_workers=2, pin_memory=True)

class_names = train_dataset.classes
num_classes = len(class_names)

print(f"📂 Classes ({num_classes}): {class_names}")
print(f"[METRICS] Training: {len(train_dataset)} images | Validation: {len(val_dataset)} images")

# %% CELL 3 - Training Function (Reusable for all models)
def train_model(model, model_name, train_loader, val_loader, num_epochs=15, lr=0.001):
    """
    Train a PyTorch model with mixed-precision, learning rate scheduling,
    and save the best checkpoint.
    """
    print(f"\n{'='*60}")
    print(f"[START] Training {model_name}")
    print(f"{'='*60}")

    model = model.to(device)
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(model.parameters(), lr=lr)
    scheduler = optim.lr_scheduler.StepLR(optimizer, step_size=5, gamma=0.5)
    scaler = GradScaler('cuda')

    best_acc = 0.0
    best_model_state = None
    history = {'train_loss': [], 'train_acc': [], 'val_loss': [], 'val_acc': []}

    start_time = time.time()

    for epoch in range(num_epochs):
        print(f"\nEpoch {epoch+1}/{num_epochs}")
        print("-" * 30)

        # --- Training Phase ---
        model.train()
        running_loss, running_correct, total = 0.0, 0, 0

        for images, labels in train_loader:
            images, labels = images.to(device), labels.to(device)
            optimizer.zero_grad()

            with autocast('cuda'):
                outputs = model(images)
                loss = criterion(outputs, labels)

            scaler.scale(loss).backward()
            scaler.step(optimizer)
            scaler.update()

            running_loss += loss.item() * images.size(0)
            _, preds = torch.max(outputs, 1)
            running_correct += (preds == labels).sum().item()
            total += labels.size(0)

        train_loss = running_loss / total
        train_acc = running_correct / total * 100
        history['train_loss'].append(train_loss)
        history['train_acc'].append(train_acc)

        # --- Validation Phase ---
        model.eval()
        val_loss, val_correct, val_total = 0.0, 0, 0

        with torch.no_grad():
            for images, labels in val_loader:
                images, labels = images.to(device), labels.to(device)
                with autocast('cuda'):
                    outputs = model(images)
                    loss = criterion(outputs, labels)
                val_loss += loss.item() * images.size(0)
                _, preds = torch.max(outputs, 1)
                val_correct += (preds == labels).sum().item()
                val_total += labels.size(0)

        val_loss = val_loss / val_total
        val_acc = val_correct / val_total * 100
        history['val_loss'].append(val_loss)
        history['val_acc'].append(val_acc)

        print(f"  Train Loss: {train_loss:.4f} | Accuracy: {train_acc:.2f}%")
        print(f"  Val   Loss: {val_loss:.4f} | Accuracy: {val_acc:.2f}%")

        if val_acc > best_acc:
            best_acc = val_acc
            best_model_state = copy.deepcopy(model.state_dict())
            print(f"  [SAVE] New Best Model (Val Acc: {best_acc:.2f}%)!")

        scheduler.step()

    elapsed = time.time() - start_time
    print(f"\n[OK] {model_name} Training Complete!")
    print(f"   Best Validation Accuracy: {best_acc:.2f}%")
    print(f"   Total Training Time: {elapsed/60:.1f} minutes")

    # Save best model
    save_path = os.path.join(SAVE_DIR, f'palmsense_{model_name.lower().replace(" ", "_")}.pth')
    torch.save({
        'model_state': best_model_state,
        'class_names': class_names,
        'accuracy': best_acc,
        'model_name': model_name,
    }, save_path)
    print(f"   [SAVE] Saved to: {save_path}")

    # Restore best weights
    model.load_state_dict(best_model_state)
    return model, history, best_acc

# %% CELL 4 - Train MobileNetV3-Large
print("[MOBILE] Building MobileNetV3-Large...")
mobilenet = models.mobilenet_v3_large(weights=models.MobileNet_V3_Large_Weights.DEFAULT)
mobilenet.classifier[3] = nn.Linear(mobilenet.classifier[3].in_features, num_classes)

mobilenet_model, mobilenet_history, mobilenet_acc = train_model(
    mobilenet, "MobileNetV3", train_loader, val_loader, num_epochs=15, lr=0.001
)

# %% CELL 5 - Train ResNet-50
print("[RESNET] Building ResNet-50...")
resnet = models.resnet50(weights=models.ResNet50_Weights.DEFAULT)
resnet.fc = nn.Linear(resnet.fc.in_features, num_classes)

resnet_model, resnet_history, resnet_acc = train_model(
    resnet, "ResNet50", train_loader, val_loader, num_epochs=15, lr=0.001
)

# %% CELL 6 - Load EfficientNet-B0 (Already Trained)
print("\n[DATA] Loading pre-trained EfficientNet-B0...")
efficientnet = models.efficientnet_b0(weights=None)
efficientnet.classifier[1] = nn.Linear(efficientnet.classifier[1].in_features, num_classes)

eff_checkpoint = torch.load(
    os.path.join(SAVE_DIR, 'palmsense_fungal_model.pth'),
    map_location=device, weights_only=False
)
efficientnet.load_state_dict(eff_checkpoint['model_state'])
efficientnet = efficientnet.to(device)
efficientnet.eval()

efficientnet_acc = eff_checkpoint.get('accuracy', 99.04)
print(f"   [OK] EfficientNet-B0 loaded (Val Acc: {efficientnet_acc:.2f}%)")

# %% CELL 7 - Ensemble Prediction (Weighted Soft Voting)
print("\n" + "="*60)
print("[ENSEMBLE] ENSEMBLE MODEL - Weighted Soft Voting")
print("="*60)

# All three models
all_models = {
    'EfficientNet-B0': (efficientnet, efficientnet_acc),
    'MobileNetV3': (mobilenet_model, mobilenet_acc),
    'ResNet-50': (resnet_model, resnet_acc),
}

# Weighted by individual validation accuracy
total_acc = sum(acc for _, acc in all_models.values())
weights = {name: acc / total_acc for name, (_, acc) in all_models.items()}
print(f"\n[METRICS] Ensemble Weights (based on individual accuracy):")
for name, w in weights.items():
    print(f"   {name}: {w:.4f}")

def ensemble_predict(models_dict, images):
    """Weighted soft-voting ensemble prediction."""
    weighted_probs = None
    for name, (model, acc) in models_dict.items():
        model.eval()
        with torch.no_grad():
            with autocast('cuda'):
                outputs = model(images)
            probs = torch.softmax(outputs, dim=1)
            w = weights[name]
            if weighted_probs is None:
                weighted_probs = probs * w
            else:
                weighted_probs += probs * w
    return weighted_probs

# Evaluate ensemble on validation set
print("\n🔍 Evaluating ensemble on validation set...")
ensemble_correct = 0
ensemble_total = 0
all_preds = []
all_labels = []

# Also track individual model predictions for comparison
individual_correct = {name: 0 for name in all_models}

for images, labels in val_loader:
    images, labels = images.to(device), labels.to(device)

    # Ensemble prediction
    ensemble_probs = ensemble_predict(all_models, images)
    _, ensemble_pred = torch.max(ensemble_probs, 1)
    ensemble_correct += (ensemble_pred == labels).sum().item()
    ensemble_total += labels.size(0)
    all_preds.extend(ensemble_pred.cpu().numpy())
    all_labels.extend(labels.cpu().numpy())

    # Individual model predictions (for comparison)
    for name, (model, _) in all_models.items():
        model.eval()
        with torch.no_grad():
            with autocast('cuda'):
                out = model(images)
            _, pred = torch.max(out, 1)
            individual_correct[name] += (pred == labels).sum().item()

ensemble_acc = ensemble_correct / ensemble_total * 100
print(f"\n{'='*60}")
print(f"[METRICS] FINAL MODEL COMPARISON TABLE")
print(f"{'='*60}")
print(f"{'Model':<25} {'Val Accuracy':>15} {'Parameters':>15}")
print(f"{'-'*55}")

model_params = {
    'EfficientNet-B0': sum(p.numel() for p in efficientnet.parameters()),
    'MobileNetV3': sum(p.numel() for p in mobilenet_model.parameters()),
    'ResNet-50': sum(p.numel() for p in resnet_model.parameters()),
}

for name in all_models:
    acc = individual_correct[name] / ensemble_total * 100
    params = model_params[name]
    print(f"{name:<25} {acc:>14.2f}% {params/1e6:>13.1f}M")

print(f"{'-'*55}")
print(f"{'[ENSEMBLE] ENSEMBLE (All 3)':<25} {ensemble_acc:>14.2f}% {'---':>15}")
print(f"{'='*55}")

# %% CELL 8 - Classification Report & Confusion Matrix (Ensemble)
print("\n[REPORT] Ensemble Classification Report:")
print(classification_report(all_labels, all_preds, target_names=class_names))

# Confusion Matrix
cm = confusion_matrix(all_labels, all_preds)
plt.figure(figsize=(10, 8))
sns.heatmap(cm, annot=True, fmt='d', cmap='Greens',
            xticklabels=class_names, yticklabels=class_names)
plt.xlabel('Predicted')
plt.ylabel('Actual')
plt.title(f'Ensemble Model - Confusion Matrix (Accuracy: {ensemble_acc:.2f}%)')
plt.tight_layout()
plt.savefig(os.path.join(SAVE_DIR, 'ensemble_confusion_matrix.png'), dpi=150)
plt.show()

# %% CELL 9 - Training History Comparison Charts
fig, axes = plt.subplots(1, 2, figsize=(16, 6))

# Accuracy comparison
for name, history in [('MobileNetV3', mobilenet_history), ('ResNet-50', resnet_history)]:
    axes[0].plot(history['val_acc'], label=f'{name}', linewidth=2)
axes[0].axhline(y=efficientnet_acc, color='green', linestyle='--', label=f'EfficientNet-B0 ({efficientnet_acc:.1f}%)')
axes[0].axhline(y=ensemble_acc, color='red', linestyle='--', linewidth=2, label=f'Ensemble ({ensemble_acc:.1f}%)')
axes[0].set_title('Validation Accuracy Comparison', fontweight='bold')
axes[0].set_xlabel('Epoch')
axes[0].set_ylabel('Accuracy (%)')
axes[0].legend()
axes[0].grid(True, alpha=0.3)

# Loss comparison
for name, history in [('MobileNetV3', mobilenet_history), ('ResNet-50', resnet_history)]:
    axes[1].plot(history['val_loss'], label=f'{name}', linewidth=2)
axes[1].set_title('Validation Loss Comparison', fontweight='bold')
axes[1].set_xlabel('Epoch')
axes[1].set_ylabel('Loss')
axes[1].legend()
axes[1].grid(True, alpha=0.3)

plt.suptitle('PalmSense - Multi-Model Training Comparison', fontsize=14, fontweight='bold')
plt.tight_layout()
plt.savefig(os.path.join(SAVE_DIR, 'model_comparison_chart.png'), dpi=150)
plt.show()

# %% CELL 10 - Save Ensemble Config
ensemble_config = {
    'models': {
        'efficientnet_b0': {
            'file': 'palmsense_fungal_model.pth',
            'accuracy': float(efficientnet_acc),
            'weight': weights['EfficientNet-B0'],
            'parameters': model_params['EfficientNet-B0'],
        },
        'mobilenetv3': {
            'file': 'palmsense_mobilenetv3.pth',
            'accuracy': float(mobilenet_acc),
            'weight': weights['MobileNetV3'],
            'parameters': model_params['MobileNetV3'],
        },
        'resnet50': {
            'file': 'palmsense_resnet50.pth',
            'accuracy': float(resnet_acc),
            'weight': weights['ResNet-50'],
            'parameters': model_params['ResNet-50'],
        },
    },
    'ensemble_accuracy': float(ensemble_acc),
    'class_names': class_names,
    'num_classes': num_classes,
}

import json
config_path = os.path.join(SAVE_DIR, 'palmsense_ensemble_config.json')
with open(config_path, 'w') as f:
    json.dump(ensemble_config, f, indent=2)

print(f"\n[OK] All models saved to Google Drive!")
print(f"   📁 palmsense_fungal_model.pth  (EfficientNet-B0)")
print(f"   📁 palmsense_mobilenetv3.pth   (MobileNetV3)")
print(f"   📁 palmsense_resnet50.pth      (ResNet-50)")
print(f"   📁 palmsense_ensemble_config.json")
print(f"\n[ENSEMBLE] Ensemble Accuracy: {ensemble_acc:.2f}%")
print(f"   (vs best individual: {max(efficientnet_acc, mobilenet_acc, resnet_acc):.2f}%)")
