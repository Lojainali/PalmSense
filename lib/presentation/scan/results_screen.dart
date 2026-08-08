import 'package:flutter/material.dart';
import '../../core/routes/app_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/models/scan_model.dart';

/// Screen: Results ("Fungal Disease Detected")
/// Reached from: CameraScreen after a capture completes.
/// Redirects:
///  - Back arrow             -> pop() (back to Dashboard, since Camera used pushReplacement)
///  - "Generate Full Report" -> AppRoutes.exportReports (push)
class ResultsScreen extends StatelessWidget {
  final ScanModel scan;
  const ResultsScreen({super.key, required this.scan});

  @override
  Widget build(BuildContext context) {
    final disease = scan.disease;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fungal Disease Detected'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${scan.blockLabel} · ${scan.dateLabel}',
                style: AppTextStyles.caption(context, size: 12.5)),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(disease.name,
                            style: AppTextStyles.heading(context, size: 19)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.severityBg(disease.severity),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${disease.severity.toUpperCase()} RISK',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.severityColor(disease.severity),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(disease.scientificName,
                      style: AppTextStyles.caption(context, size: 13).copyWith(
                          fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('AI Confidence', style: AppTextStyles.body(context, size: 13)),
                      Text('${scan.confidence.toInt()}%',
                          style: TextStyle(
                              color: AppColors.critical,
                              fontWeight: FontWeight.w800,
                              fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: scan.confidence / 100,
                      minHeight: 7,
                      backgroundColor: Theme.of(context).dividerColor,
                      valueColor: AlwaysStoppedAnimation(AppColors.critical),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(disease.description, style: AppTextStyles.body(context, size: 13.5)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Differential Analysis', style: AppTextStyles.heading(context, size: 16)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: disease.differentialAnalysis.map((d) {
                  final isTop = d == disease.differentialAnalysis.first;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(d.name, style: AppTextStyles.body(context, size: 13.5)),
                            Text('${d.confidence.toInt()}%',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isTop ? AppColors.critical : AppColors.low,
                                    fontSize: 13)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: d.confidence / 100,
                            minHeight: 5,
                            backgroundColor: Theme.of(context).dividerColor,
                            valueColor: AlwaysStoppedAnimation(
                                isTop ? AppColors.critical : AppColors.low),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Recommended Actions', style: AppTextStyles.heading(context, size: 16)),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: disease.recommendedActions.asMap().entries.map((entry) {
                  const icons = [Icons.science_outlined, Icons.warning_amber_rounded, Icons.opacity];
                  final icon = icons[entry.key % icons.length];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(entry.value, style: AppTextStyles.body(context, size: 13.5))),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Generate Full Report',
              onPressed: () => Navigator.of(context).pushNamed(AppRoutes.exportReports),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
