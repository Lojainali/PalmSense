import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/disease_model.dart';
import '../../logic/library/library_cubit.dart';
import '../../logic/library/library_state.dart';

/// Screen: Fungal Disease Library (tab 1 of MainShell)
/// Redirects:
///  - Tapping a disease card -> AppRoutes.diseaseDetail (push), passes DiseaseModel
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fungal Disease Library'),
      ),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: TextField(
                  onChanged: (v) => context.read<LibraryCubit>().search(v),
                  decoration: const InputDecoration(
                    hintText: 'Search diseases...',
                    prefixIcon: Icon(Icons.search, size: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: ['All', 'Critical', 'High', 'Medium', 'Low'].map((s) {
                    final selected = state.severityFilter == s;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s),
                        selected: selected,
                        onSelected: (_) => context.read<LibraryCubit>().filterBySeverity(s),
                        selectedColor: s == 'All'
                            ? AppColors.primary
                            : AppColors.severityColor(s),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.5,
                        ),
                        backgroundColor: Theme.of(context).cardColor,
                        side: BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: state.results.isEmpty
                    ? Center(
                  child: Text('No diseases match your filters',
                      style: AppTextStyles.caption(context)),
                )
                    : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: state.results.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _DiseaseCard(disease: state.results[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DiseaseCard extends StatelessWidget {
  final DiseaseModel disease;
  const _DiseaseCard({required this.disease});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.of(context).pushNamed(AppRoutes.diseaseDetail, arguments: disease),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: disease.swatch.withOpacity(0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(disease.icon, color: disease.swatch, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(disease.name,
                            style: AppTextStyles.body(context, size: 14.5)
                                .copyWith(fontWeight: FontWeight.w700)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.severityBg(disease.severity),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          disease.severity,
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.severityColor(disease.severity),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(disease.scientificName,
                      style: AppTextStyles.caption(context, size: 12.5)
                          .copyWith(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 3),
                  Text('${disease.recordedCases} recorded cases',
                      style: AppTextStyles.caption(context, size: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
