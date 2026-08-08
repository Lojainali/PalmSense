import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class NotificationPrefsState extends Equatable {
  final bool criticalAlerts;
  final bool scanReminders;
  final bool weeklyReports;
  final bool communityUpdates;

  const NotificationPrefsState({
    this.criticalAlerts = true,
    this.scanReminders = true,
    this.weeklyReports = false,
    this.communityUpdates = false,
  });

  NotificationPrefsState copyWith({
    bool? criticalAlerts,
    bool? scanReminders,
    bool? weeklyReports,
    bool? communityUpdates,
  }) {
    return NotificationPrefsState(
      criticalAlerts: criticalAlerts ?? this.criticalAlerts,
      scanReminders: scanReminders ?? this.scanReminders,
      weeklyReports: weeklyReports ?? this.weeklyReports,
      communityUpdates: communityUpdates ?? this.communityUpdates,
    );
  }

  @override
  List<Object?> get props => [criticalAlerts, scanReminders, weeklyReports, communityUpdates];
}

/// Backs the Notification Preferences screen toggles.
class NotificationPrefsCubit extends Cubit<NotificationPrefsState> {
  NotificationPrefsCubit() : super(const NotificationPrefsState());

  void toggleCritical(bool value) => emit(state.copyWith(criticalAlerts: value));
  void toggleReminders(bool value) => emit(state.copyWith(scanReminders: value));
  void toggleWeekly(bool value) => emit(state.copyWith(weeklyReports: value));
  void toggleCommunity(bool value) => emit(state.copyWith(communityUpdates: value));
}
