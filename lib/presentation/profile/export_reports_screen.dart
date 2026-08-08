import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';

/// Screen: Export Reports (Profile -> Diagnostics -> Export Reports,
/// also reached from Results -> "Generate Full Report")
/// No further redirects — each row simulates an export via a snackbar.
class ExportReportsScreen extends StatelessWidget {
  const ExportReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scans = MockData.scanHistory;
    return Scaffold(
      appBar: AppBar(title: const Text('Export Reports')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Generate a PDF report for any past scan or the whole farm.',
              style: AppTextStyles.caption(context, size: 13)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                const Icon(Icons.summarize_outlined, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Full Farm Health Report',
                      style: AppTextStyles.body(context, size: 14)
                          .copyWith(fontWeight: FontWeight.w700)),
                ),
                TextButton(
                  onPressed: () => _exportSnack(context, 'Full Farm Health Report'),
                  child: const Text('Export'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('By Scan', style: AppTextStyles.heading(context, size: 15)),
          const SizedBox(height: 10),
          ...scans.map((scan) => Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf_outlined, color: scan.disease.swatch),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(scan.disease.name,
                          style: AppTextStyles.body(context, size: 13.5)
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text('${scan.blockLabel} · ${scan.dateLabel}',
                          style: AppTextStyles.caption(context, size: 11.5)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.ios_share, size: 20),
                  onPressed: () => _exportSnack(context, scan.disease.name),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  void _exportSnack(BuildContext context, String label) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Exporting "$label"…')));
  }
}
