import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_text_styles.dart';
import '../../logic/notification_prefs/notification_prefs_cubit.dart';

class NotificationPreferencesScreen extends StatelessWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationPrefsCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notification Preferences')),
        body: BlocBuilder<NotificationPrefsCubit, NotificationPrefsState>(
          builder: (context, state) {
            final cubit = context.read<NotificationPrefsCubit>();
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text('Manage which alerts PalmSense sends you.',
                    style: AppTextStyles.caption(context, size: 13)),
                const SizedBox(height: 16),
                _ToggleTile(
                  title: 'Critical Disease Alerts',
                  subtitle: 'Immediate push notification for high-risk detections',
                  value: state.criticalAlerts,
                  onChanged: cubit.toggleCritical,
                ),
                _ToggleTile(
                  title: 'Scan Reminders',
                  subtitle: 'Reminders to run your daily block scans',
                  value: state.scanReminders,
                  onChanged: cubit.toggleReminders,
                ),
                _ToggleTile(
                  title: 'Weekly Reports',
                  subtitle: 'A summary of farm health every Monday',
                  value: state.weeklyReports,
                  onChanged: cubit.toggleWeekly,
                ),
                _ToggleTile(
                  title: 'Community Updates',
                  subtitle: 'News from the PalmSense research network',
                  value: state.communityUpdates,
                  onChanged: cubit.toggleCommunity,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: AppTextStyles.body(context, size: 14).copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: AppTextStyles.caption(context, size: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
