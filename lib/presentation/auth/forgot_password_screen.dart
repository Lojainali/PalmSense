import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.lock_reset_rounded, size: 44, color: isDark ? AppColors.accent : AppColors.primary),
            const SizedBox(height: 16),
            Text('Forgot your password?', style: AppTextStyles.heading(context, size: 20)),
            const SizedBox(height: 8),
            Text(
              "Enter the email associated with your account and we'll send a link to reset your password.",
              style: AppTextStyles.caption(context, size: 14),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Email Address',
              hint: 'example@gmail.com',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            if (_sent)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.lowBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: AppColors.low, size: 20),
                    SizedBox(width: 10),
                    Expanded(child: Text('Reset link sent — check your inbox.')),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            PrimaryButton(
              label: _sent ? 'Back to Sign In' : 'Send Reset Link',
              onPressed: () {
                if (_sent) {
                  Navigator.of(context).pop();
                } else {
                  setState(() => _sent = true);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
