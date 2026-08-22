import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';

import '../../logic/language/language_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _farmNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _blocksController = TextEditingController();
  final _palmCountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _farmNameController.dispose();
    _locationController.dispose();
    _blocksController.dispose();
    _palmCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
          appBar: AppBar(title: Text(isAr ? 'إنشاء حسابك المجاني' : 'Create your free account')),
          body: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.mainShell,
                      (route) => false,
                );
              } else if (state.status == AuthStatus.failure && state.errorMessage != null) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(isAr ? 'إنشاء حساب' : 'Create Account', style: AppTextStyles.heading(context, size: 24)),
                    const SizedBox(height: 24),
                    CustomTextField(
                      label: isAr ? 'الاسم الكامل' : 'Full Name',
                      hint: isAr ? 'الاسم الكامل' : 'Full Name',
                      controller: _nameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: isAr ? 'البريد الإلكتروني' : 'Email Address',
                      hint: 'example@gmail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: isAr ? 'اسم المزرعة' : 'Farm Name',
                      hint: isAr ? 'مثال: مزرعة النخيل بالمدينة' : 'e.g. Al-Madinah Palm Grove',
                      controller: _farmNameController,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: isAr ? 'الموقع' : 'Location',
                      hint: isAr ? 'مثال: الرياض، السعودية' : 'e.g. Riyadh, KSA',
                      controller: _locationController,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: isAr ? 'عدد الكتل' : 'Number of Blocks',
                            hint: 'e.g. 6',
                            controller: _blocksController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: isAr ? 'عدد النخيل' : 'Total Palm Count',
                            hint: 'e.g. 100',
                            controller: _palmCountController,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: isAr ? 'كلمة المرور' : 'Password',
                      hint: isAr ? 'كلمة المرور' : 'Password',
                      controller: _passwordController,
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
                      hint: isAr ? 'تأكيد كلمة المرور' : 'Confirm Password',
                      controller: _confirmController,
                      isPasswordField: true,
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: isAr ? 'إنشاء حساب' : 'Create Account',
                      loading: state.status == AuthStatus.submitting,
                      onPressed: () => context.read<AuthCubit>().signUp(
                        fullName: _nameController.text,
                        email: _emailController.text,
                        password: _passwordController.text,
                        confirmPassword: _confirmController.text,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Wrap(
                        children: [
                          Text(isAr ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ',
                              style: AppTextStyles.body(context)),
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Text(
                              isAr ? 'تسجيل الدخول' : 'Sign In',
                              style: TextStyle(
                                color: isDark ? AppColors.accent : AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
