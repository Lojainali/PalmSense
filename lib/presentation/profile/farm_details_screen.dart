import 'package:flutter/material.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock/mock_data.dart';

/// Screen: Farm Details (Profile -> Account -> Farm Details)
/// Redirects:
///  - "Save Changes" -> pop() back to Profile
class FarmDetailsScreen extends StatefulWidget {
  const FarmDetailsScreen({super.key});

  @override
  State<FarmDetailsScreen> createState() => _FarmDetailsScreenState();
}

class _FarmDetailsScreenState extends State<FarmDetailsScreen> {
  late final _farmNameController = TextEditingController(text: MockData.currentUser.farmName);
  late final _locationController = TextEditingController(text: 'Al Ain, Abu Dhabi, UAE');
  late final _blocksController =
  TextEditingController(text: '${MockData.currentUser.farmBlocks}');
  late final _palmCountController = TextEditingController(text: '1,240');

  @override
  void dispose() {
    _farmNameController.dispose();
    _locationController.dispose();
    _blocksController.dispose();
    _palmCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farm Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
                label: 'Farm Name', hint: 'Farm name', controller: _farmNameController),
            const SizedBox(height: 16),
            CustomTextField(
                label: 'Location', hint: 'City, region', controller: _locationController),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Number of Blocks',
              hint: 'e.g. 6',
              controller: _blocksController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Total Palm Count',
              hint: 'e.g. 1,240',
              controller: _palmCountController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Save Changes',
              onPressed: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Farm details updated')));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
