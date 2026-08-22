import 'package:equatable/equatable.dart';
import '../../data/models/disease_model.dart';

class LibraryState extends Equatable {
  final String query;
  final String severityFilter;
  final List<DiseaseModel> results;

  const LibraryState({
    this.query = '',
    this.severityFilter = 'All',
    this.results = const [],
  });

  LibraryState copyWith({
    String? query,
    String? severityFilter,
    List<DiseaseModel>? results,
  }) {
    return LibraryState(
      query: query ?? this.query,
      severityFilter: severityFilter ?? this.severityFilter,
      results: results ?? this.results,
    );
  }

  @override
  List<Object?> get props => [query, severityFilter, results];
}
