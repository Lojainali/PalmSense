import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/settings_tile.dart';
import '../../core/widgets/stat_chip.dart';
import '../../data/mock/mock_data.dart';
import '../../logic/auth/auth_cubit.dart';

/// Screen: Profile (tab 2 of MainShell)
/// Redirects:
///  Account   -> Edit Profile / Farm Details / Notification Preferences
///  Diagnostics -> Scan History / Export Reports / AI Model Version
///  App       -> Language / Dark Mode / Help & Support
///  Sign Out  -> confirm dialog -> AppRoutes.login (pushNamedAndRemoveUntil)
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = context.watch<AuthCubit>().state.user ?? MockData.currentUser;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                decoration: BoxDecoration(
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
                      backgroundColor: Colors.white.withOpacity(0.2),
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
                          label: 'Total\nScans',
                          background: Colors.white.withOpacity(0.12),
                          foreground: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        StatChip(
                          value: '${user.diseasesFound}',
                          label: 'Diseases\nFound',
                          background: Colors.white.withOpacity(0.12),
                          foreground: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        StatChip(
                          value: '${user.farmBlocks}',
                          label: 'Farm\nBlocks',
                          background: Colors.white.withOpacity(0.12),
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
                    _GroupLabel('ACCOUNT'),
                    _Card(children: [
                      SettingsTile(
                        title: 'Edit Profile',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'Farm Details',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.farmDetails),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'Notification Preferences',
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoutes.notificationPreferences),
                      ),
                    ]),
                    const SizedBox(height: 22),
                    _GroupLabel('DIAGNOSTICS'),
                    _Card(children: [
                      SettingsTile(
                        title: 'Scan History',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.scanHistory),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'Export Reports',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.exportReports),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'AI Model Version',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.aiModelVersion),
                      ),
                    ]),
                    const SizedBox(height: 22),
                    _GroupLabel('APP'),
                    _Card(children: [
                      SettingsTile(
                        title: 'Language',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.language),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'Dark Mode',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.darkMode),
                      ),
                      const _Divider(),
                      SettingsTile(
                        title: 'Help & Support',
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.helpSupport),
                      ),
                    ]),
                    const SizedBox(height: 22),
                    _Card(children: [
                      SettingsTile(
                        title: 'Sign Out',
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
