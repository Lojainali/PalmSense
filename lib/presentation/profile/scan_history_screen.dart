import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/mock/mock_data.dart';
import '../../logic/language/language_cubit.dart';

class ScanHistoryScreen extends StatelessWidget {
  const ScanHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scans = MockData.scanHistory;
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
          appBar: AppBar(title: Text(isAr ? 'سجل الفحوصات' : 'Scan History')),
          body: scans.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history_outlined, size: 64, color: Theme.of(context).disabledColor),
                        const SizedBox(height: 16),
                        Text(
                          isAr ? 'لا يوجد سجل فحوصات حتى الآن' : 'No Scan History Yet',
                          style: AppTextStyles.heading(context, size: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isAr
                              ? 'سيتم حفظ جميع فحوصات أمراض سعف النخيل وعرضها هنا.'
                              : 'All your palm leaf disease scans will be saved and displayed here.',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption(context, size: 13),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: scans.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    final scan = scans[i];
                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.diseaseDetail, arguments: scan.disease),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: scan.disease.swatch.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(scan.disease.icon, color: scan.disease.swatch),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(scan.disease.name,
                                      style: AppTextStyles.body(context, size: 14)
                                          .copyWith(fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Text('${scan.blockLabel} · ${scan.dateLabel}',
                                      style: AppTextStyles.caption(context, size: 12)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.severityBg(scan.disease.severity),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                scan.disease.severity,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.severityColor(scan.disease.severity),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
