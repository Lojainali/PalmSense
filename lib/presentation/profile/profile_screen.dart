import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/settings_tile.dart';
import '../../core/widgets/stat_chip.dart';
import '../../data/mock/mock_data.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/language/language_cubit.dart';
import '../../logic/theme/theme_cubit.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthCubit>().state.user ?? MockData.currentUser;

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
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primaryDark, AppColors.primary],
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          child: Text(user.initials,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(height: 12),
                        Text(user.fullName,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 2),
                        Text(user.email, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            StatChip(
                              value: '${user.totalScans}',
                              label: isAr ? 'إجمالي\nالفحوصات' : 'Total\nScans',
                              background: Colors.white.withValues(alpha: 0.12),
                              foreground: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            StatChip(
                              value: '${user.diseasesFound}',
                              label: isAr ? 'الإصابات\nالمكتشفة' : 'Diseases\nFound',
                              background: Colors.white.withValues(alpha: 0.12),
                              foreground: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            StatChip(
                              value: '${user.farmBlocks}',
                              label: isAr ? 'كتل\nالمزرعة' : 'Farm\nBlocks',
                              background: Colors.white.withValues(alpha: 0.12),
                              foreground: Colors.white,
                            ),
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
                        _GroupLabel(isAr ? 'الحساب' : 'ACCOUNT'),
                        _Card(children: [
                          SettingsTile(
                            title: isAr ? 'تعديل الملف الشخصي' : 'Edit Profile',
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
                          ),
                          const _Divider(),
                          SettingsTile(
                            title: isAr ? 'تفاصيل المزرعة' : 'Farm Details',
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.farmDetails),
                          ),
                          const _Divider(),
                          SettingsTile(
                            title: isAr ? 'تفضيلات الإشعارات' : 'Notification Preferences',
                            onTap: () =>
                                Navigator.of(context).pushNamed(AppRoutes.notificationPreferences),
                          ),
                        ]),
                        const SizedBox(height: 22),
                        _GroupLabel(isAr ? 'التشخيص والفحص' : 'DIAGNOSTICS'),
                        _Card(children: [
                          SettingsTile(
                            title: isAr ? 'سجل الفحوصات' : 'Scan History',
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.scanHistory),
                          ),
                        ]),
                        const SizedBox(height: 22),
                        _GroupLabel(isAr ? 'التطبيق' : 'APP'),
                        _Card(children: [
                          SettingsTile(
                            title: isAr ? 'اللغة' : 'Language',
                            onTap: () => Navigator.of(context).pushNamed(AppRoutes.language),
                          ),
                          const _Divider(),
                          SettingsTile(
                            title: isAr ? 'المظهر' : 'Brightness',
                            trailing: Icon(
                              isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                            ),
                            onTap: () => context.read<ThemeCubit>().toggle(),
                          ),
                        ]),
                        const SizedBox(height: 22),
                        _Card(children: [
                          SettingsTile(
                            title: isAr ? 'تسجيل الخروج' : 'Sign Out',
                            titleColor: AppColors.critical,
                            trailing: const SizedBox.shrink(),
                            onTap: () => _confirmSignOut(context),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        Center(
                          child: Text('PalmSense v2.4.1 · AI Model 3.1-fungal',
                              style: AppTextStyles.caption(context, size: 12)),
                        ),
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

  void _confirmSignOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of PalmSense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthCubit>().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (r) => false);
            },
            child: const Text('Sign Out', style: TextStyle(color: AppColors.critical)),
          ),
        ],
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  final String text;
  const _GroupLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 4),
      child: Text(text, style: AppTextStyles.label(context)),
    );
  }
}

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(children: children),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Divider(height: 1, color: Theme.of(context).dividerColor);
}
