import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/severity_badge.dart';
import '../../data/models/disease_model.dart';

/// Screen: Disease Detail (reference entry)
/// Reached from: Library screen (tap a disease card) or Dashboard "Recent Scans".
/// Redirects:
///  - Back arrow -> pop() back to the caller (Library or Dashboard)
class DiseaseDetailScreen extends StatelessWidget {
  final DiseaseModel disease;
  const DiseaseDetailScreen({super.key, required this.disease});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(disease.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: disease.swatch.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(disease.icon, color: disease.swatch, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(disease.name, style: AppTextStyles.heading(context, size: 18)),
                      const SizedBox(height: 2),
                      Text(disease.scientificName,
                          style: AppTextStyles.caption(context, size: 13)
                              .copyWith(fontStyle: FontStyle.italic)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SeverityBadge(severity: disease.severity),
                const SizedBox(width: 10),
                Text('${disease.recordedCases} recorded cases',
                    style: AppTextStyles.caption(context, size: 13)),
              ],
            ),
            const SizedBox(height: 20),
            Text('Overview', style: AppTextStyles.heading(context, size: 16)),
            const SizedBox(height: 10),
            Text(disease.description, style: AppTextStyles.body(context, size: 14)),
            const SizedBox(height: 24),
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
                children: disease.recommendedActions
                    .map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline, size: 18, color: AppColors.primary),
                      const SizedBox(width: 10),
                      Expanded(child: Text(a, style: AppTextStyles.body(context, size: 13.5))),
                    ],
                  ),
                ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
