import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../data/mock/mock_data.dart';
import '../../logic/auth/auth_cubit.dart';

import '../../logic/language/language_cubit.dart';

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
    _phoneController = TextEditingController(text: user.phoneNumber.isNotEmpty ? user.phoneNumber : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Please fill in required fields')));
      return;
    }

    context.read<AuthCubit>().updateProfile(
      fullName: _nameController.text,
      email: _emailController.text,
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated')));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
          appBar: AppBar(title: Text(isAr ? 'تعديل الملف الشخصي' : 'Edit Profile')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  label: isAr ? 'الاسم الكامل' : 'Full Name',
                  hint: isAr ? 'الاسم الكامل' : 'Full Name',
                  controller: _nameController,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: isAr ? 'البريد الإلكتروني' : 'Email Address',
                  hint: 'Email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  label: isAr ? 'رقم الهاتف' : 'Phone Number',
                  hint: '+20 123 456 7890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
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
