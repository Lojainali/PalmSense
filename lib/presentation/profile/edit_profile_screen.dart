import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock/mock_data.dart';
import '../../logic/auth/auth_cubit.dart';

/// Screen: Edit Profile (Profile -> Account -> Edit Profile)
/// Redirects:
///  - "Save Changes" -> updates AuthCubit user, then pop() back to Profile
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state.user ?? MockData.currentUser;
    _nameController = TextEditingController(text: user.fullName);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: '+971 50 123 4567');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(label: 'Full Name', hint: 'Full name', controller: _nameController),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Address',
              hint: 'Email address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Phone Number',
              hint: 'Phone number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: 'Save Changes',
              onPressed: () {
                context.read<AuthCubit>().updateProfile(
                  fullName: _nameController.text,
                  email: _emailController.text,
                );
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Profile updated')));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
