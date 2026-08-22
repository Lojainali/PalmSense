import 'package:flutter/material.dart';
import 'disease_model.dart';

class ScanModel {
  final String id;
  final DiseaseModel disease;
  final String blockLabel;
  final String dateLabel;
  final String timeAgo;
  final double confidence;

  const ScanModel({
    required this.id,
    required this.disease,
    required this.blockLabel,
    required this.dateLabel,
    required this.timeAgo,
    required this.confidence,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'diseaseId': disease.id,
        'diseaseName': disease.name,
        'blockLabel': blockLabel,
        'dateLabel': dateLabel,
        'timeAgo': timeAgo,
        'confidence': confidence,
      };

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    return ScanModel(
      id: json['id'] as String? ?? '',
      disease: DiseaseModel(
        id: json['diseaseId'] as String? ?? 'healthy',
        name: json['diseaseName'] as String? ?? 'Healthy',
        scientificName: '',
        severity: 'Low',
        recordedCases: 0,
        description: '',
        icon: Icons.eco,
        swatch: Colors.green,
      ),
      blockLabel: json['blockLabel'] as String? ?? '',
      dateLabel: json['dateLabel'] as String? ?? '',
      timeAgo: json['timeAgo'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class AlertModel {
  final String diseaseName;
  final String blockLabel;
  final String severity;

  const AlertModel({
    required this.diseaseName,
    required this.blockLabel,
    required this.severity,
  });
}
