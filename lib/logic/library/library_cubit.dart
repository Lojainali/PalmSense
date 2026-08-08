import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock/mock_data.dart';
import 'library_state.dart';

/// Backs the Fungal Disease Library screen: free-text search over the
/// disease name/scientific name plus a severity chip filter (All /
/// Critical / High / Medium / Low), mirroring the recorded GUI.
class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit() : super(LibraryState(results: MockData.diseaseLibrary)) {
    _applyFilters();
  }

  void search(String query) {
    emit(state.copyWith(query: query));
    _applyFilters();
  }

  void filterBySeverity(String severity) {
    emit(state.copyWith(severityFilter: severity));
    _applyFilters();
  }

  /// Called from the Dashboard's "View all" alerts link to jump straight
  /// into a pre-filtered library (e.g. only High severity items).
  void presetSeverityFilter(String severity) {
    emit(state.copyWith(severityFilter: severity, query: ''));
    _applyFilters();
  }

  void _applyFilters() {
    final all = MockData.diseaseLibrary;
    final filtered = all.where((d) {
      final matchesSeverity =
          state.severityFilter == 'All' || d.severity == state.severityFilter;
      final matchesQuery = state.query.trim().isEmpty ||
          d.name.toLowerCase().contains(state.query.toLowerCase()) ||
          d.scientificName.toLowerCase().contains(state.query.toLowerCase());
      return matchesSeverity && matchesQuery;
    }).toList();
    emit(state.copyWith(results: filtered));
  }
}
