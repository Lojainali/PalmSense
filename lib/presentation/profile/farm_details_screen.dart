import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../logic/language/language_cubit.dart';

class FarmDetailsScreen extends StatefulWidget {
  const FarmDetailsScreen({super.key});

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  late final _farmNameController = TextEditingController(text: '');
  late final _locationController = TextEditingController(text: '');
  late final _blocksController = TextEditingController(text: '');
  late final _palmCountController = TextEditingController(text: '');

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    _blocksController.dispose();
    _palmCountController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_farmNameController.text.trim().isEmpty ||
        _locationController.text.trim().isEmpty ||
        _blocksController.text.trim().isEmpty ||
        _palmCountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Farm details updated')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
          appBar: AppBar(title: Text(isAr ? 'تفاصيل المزرعة' : 'Farm Details')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: isAr ? 'اسم المزرعة' : 'Farm Name',
                  hint: isAr ? 'اسم المزرعة' : 'Farm name',
                  controller: _farmNameController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: isAr ? 'الموقع' : 'Location',
                  hint: isAr ? 'المدينة، المنطقة' : 'City, region',
                  controller: _locationController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: isAr ? 'عدد الكتل' : 'Number of Blocks',
                  hint: 'e.g. 6',
                  controller: _blocksController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: isAr ? 'إجمالي عدد النخيل' : 'Total Palm Count',
                  hint: 'e.g. 1,240',
                  controller: _palmCountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  label: isAr ? 'حفظ التغييرات' : 'Save Changes',
                  onPressed: _saveChanges,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
