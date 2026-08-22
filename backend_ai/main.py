"""
PalmSense AI Inference API (FastAPI Backend)

This server hosts your trained Machine Learning / Deep Learning model
(e.g., PyTorch, TensorFlow, MobileNet, EfficientNet) to classify
date palm fungal diseases from leaf images.
"""

from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import uvicorn
import io

app = FastAPI(
    title="PalmSense AI Inference Engine",
    description="Fungal Disease Classification API for Date Palms",
    version="1.0.0"
)

# Enable CORS for mobile app requests
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Disease classes mapping based on dataset
DISEASE_CLASSES = {
    0: {
        "disease_name": "Black Scorch",
        "scientific_name": "Thielaviopsis paradoxa",
        "is_fungal": True,
        "severity": "High",
        "treatment": "Prune affected fronds, apply copper oxychloride or systemic fungicide."
    },
    1: {
        "disease_name": "Fusarium Wilt",
        "scientific_name": "Fusarium oxysporum",
        "is_fungal": True,
        "severity": "Critical",
        "treatment": "Soil drench with systemic fungicide, quarantine infected palms."
    },
    2: {
        "disease_name": "Rachis Blight",
        "scientific_name": "Serenomyces palmorum",
        "is_fungal": True,
        "severity": "Moderate",
        "treatment": "Spray preventive fungicide during humid seasons."
    },
    3: {
        "disease_name": "Leaf Spots / Brown Spots",
        "scientific_name": "Graphiola phoenicis / Bipolaris",
        "is_fungal": True,
        "severity": "Moderate",
        "treatment": "Apply copper-based fungicide spray, avoid overhead irrigation."
    },
    4: {
        "disease_name": "Healthy",
        "scientific_name": "Phoenix dactylifera",
        "is_fungal": False,
        "severity": "None",
        "treatment": "No treatment required. Palm frond is healthy."
    }
}

@app.get("/")
def health_check():
    return {"status": "online", "service": "PalmSense AI Inference API"}

@app.post("/api/v1/predict")
async def predict_disease(file: UploadFile = File(...)):
    """
    Predicts date palm disease from an uploaded leaf image.
    """
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="Uploaded file must be an image.")

    contents = await file.read()
    
    # TODO: Load your trained PyTorch (.pt) or TensorFlow (.h5) model here.
    # Placeholder prediction structure:
    predicted_class_id = 0  # Replace with model.predict(image)
    disease_info = DISEASE_CLASSES.get(predicted_class_id, DISEASE_CLASSES[4])

    return {
        "disease_name": disease_info["disease_name"],
        "scientific_name": disease_info["scientific_name"],
        "confidence": 0.95,
        "is_fungal": disease_info["is_fungal"],
        "severity": disease_info["severity"],
        "recommended_treatment": disease_info["treatment"]
    }

if __name__ == "__main__":
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
