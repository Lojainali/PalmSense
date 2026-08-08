import 'package:flutter/material.dart';

/// A reference entry in the Fungal Disease Library, and also the shape
/// used to describe a disease detected during a scan.
class DiseaseModel {
  final String id;
  final String name;
  final String scientificName;
  final String severity; // Critical, High, Medium, Low
  final int recordedCases;
  final String description;
  final IconData icon;
  final Color swatch;
  final List<String> recommendedActions;
  final List<DifferentialResult> differentialAnalysis;

  const DiseaseModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.severity,
    required this.recordedCases,
    required this.description,
    required this.icon,
    required this.swatch,
    this.recommendedActions = const [],
    this.differentialAnalysis = const [],
  });
}

class DifferentialResult {
  final String name;
  final double confidence; // 0-100

  const DifferentialResult({required this.name, required this.confidence});
}
