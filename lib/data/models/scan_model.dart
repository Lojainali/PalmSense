import 'disease_model.dart';

/// Represents a single completed scan result, tying a [DiseaseModel]
/// diagnosis to a palm block, timestamp and AI confidence score.
class ScanModel {
  final String id;
  final DiseaseModel disease;
  final String blockLabel; // e.g. "Block C-4 · Palm #12"
  final String dateLabel; // e.g. "07 Aug 2026"
  final String timeAgo; // e.g. "2h ago"
  final double confidence; // 0-100

  const ScanModel({
    required this.id,
    required this.disease,
    required this.blockLabel,
    required this.dateLabel,
    required this.timeAgo,
    required this.confidence,
  });
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
