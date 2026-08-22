import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/section_title.dart';
import '../../core/widgets/severity_badge.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/scan_model.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/library/library_cubit.dart';
import '../../logic/main_nav/main_nav_cubit.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthCubit>().state.user ?? MockData.currentUser;
    final alerts = MockData.activeAlerts;
    final recentScans = MockData.recentScans;

    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(isAr ? 'صباح الخير،' : 'Good morning,',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 2),
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => context.read<MainNavCubit>().goToProfile(),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                child: Text(
                                  user.initials,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _HeaderStat(value: '${user.totalScans}', label: isAr ? 'فحوصات اليوم' : 'Scans Today'),
                            const SizedBox(width: 10),
                            _HeaderStat(value: '${alerts.length}', label: isAr ? 'تنبهات نشطة' : 'Active Alerts'),
                            const SizedBox(width: 10),
                            _HeaderStat(value: user.totalScans == 0 ? '100%' : '91%', label: isAr ? 'نخيل سليم' : 'Healthy'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => Navigator.of(context).pushNamed(AppRoutes.camera),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.accent : AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(Icons.camera_alt_rounded, color: Colors.white),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(isAr ? 'بدء فحص جديد' : 'Start New Scan',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700)),
                                      const SizedBox(height: 2),
                                      Text(isAr ? 'كشف الأمراض الفطرية فوراً' : 'Detect fungal disease instantly',
                                          style: const TextStyle(color: Colors.white70, fontSize: 12.5)),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right_rounded, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),
                        SectionTitle(
                          title: isAr ? 'تنبيهات نشطة' : 'Active Alerts',
                          trailingLabel: alerts.isEmpty ? '' : (isAr ? 'عرض الكل' : 'View all'),
                          onTrailingTap: alerts.isEmpty ? null : () {
                            context.read<LibraryCubit>().presetSeverityFilter('High');
                            context.read<MainNavCubit>().goToLibrary();
                          },
                        ),
                        const SizedBox(height: 12),
                        if (alerts.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Theme.of(context).dividerColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                                const SizedBox(width: 10),
                                Text(isAr ? 'لا توجد تنبيهات نشطة. جميع النخيل سليم!' : 'No active alerts. All palm trees are healthy!',
                                    style: const TextStyle(fontSize: 13)),
                              ],
                            ),
                          )
                        else
                          ...alerts.map((alert) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () {
                                context.read<LibraryCubit>().presetSeverityFilter(alert.severity);
                                context.read<MainNavCubit>().goToLibrary();
                              },
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
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: AppColors.severityColor(alert.severity),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(alert.diseaseName,
                                              style: AppTextStyles.body(context, size: 14.5)
                                                  .copyWith(fontWeight: FontWeight.w700)),
                                          const SizedBox(height: 2),
                                          Text(alert.blockLabel, style: AppTextStyles.caption(context)),
                                        ],
                                      ),
                                    ),
                                    SeverityBadge(severity: alert.severity),
                                  ],
                                ),
                              ),
                            ),
                          )),
                        const SizedBox(height: 16),
                        SectionTitle(title: isAr ? 'الفحوصات الأخيرة' : 'Recent Scans'),
                        const SizedBox(height: 12),
                        if (recentScans.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: Theme.of(context).dividerColor),
                            ),
                            child: Column(
                              children: [
                                const Icon(Icons.history_outlined, size: 36, color: Colors.grey),
                                const SizedBox(height: 8),
                                Text(isAr ? 'لا توجد فحوصات سابقة' : 'No recent scans performed yet',
                                    style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Text(isAr ? 'اضغط "بدء فحص جديد" لفحص أول سعفة.' : 'Tap "Start New Scan" above to scan your first frond.',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          )
                        else
                          ...recentScans.map((scan) => _RecentScanTile(scan: scan)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color:Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RecentScanTile extends StatelessWidget {
  final ScanModel scan;
  const _RecentScanTile({required this.scan});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).pushNamed(
          AppRoutes.diseaseDetail,
          arguments: scan.disease,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: scan.confidence / 100,
                              minHeight: 5,
                              backgroundColor: Theme.of(context).dividerColor,
                              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${scan.confidence.toInt()}%',
                            style: AppTextStyles.caption(context, size: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(scan.timeAgo, style: AppTextStyles.caption(context, size: 11)),
            ],
          ),
        ),
      ),
    );
  }
}
