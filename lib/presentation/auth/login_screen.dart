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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return BlocBuilder<LanguageCubit, String>(
      builder: (context, lang) {
        final isAr = lang.contains('ar') || lang.contains('العربية');
        return Scaffold(
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
              return SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppColors.primaryDark, AppColors.primary],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.eco, color: Colors.white, size: 22),
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'PalmSense',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Text(
                              isAr
                                  ? 'الكشف عن الأمراض الفطرية للنخيل باستخدام الذكاء الاصطناعي'
                                  : 'AI-powered fungal disease detection for date palms',
                              style: const TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isAr ? 'مرحباً بك مجدداً' : 'Welcome back',
                                style: AppTextStyles.heading(context, size: 24)),
                            const SizedBox(height: 6),
                            Text(isAr ? 'قم بتسجيل الدخول إلى حسابك' : 'Sign in to your account',
                                style: AppTextStyles.caption(context, size: 14)),
                            const SizedBox(height: 24),
                            CustomTextField(
                              label: isAr ? 'البريد الإلكتروني' : 'Email Address',
                              hint: 'example@gmail.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 18),
                            CustomTextField(
                              label: isAr ? 'كلمة المرور' : 'Password',
                              hint: isAr ? 'كلمة المرور' : 'Password',
                              controller: _passwordController,
                              isPasswordField: true,
                            ),
                            const SizedBox(height: 24),
                            PrimaryButton(
                              label: isAr ? 'تسجيل الدخول' : 'Sign In',
                              loading: state.status == AuthStatus.submitting,
                              onPressed: () => context.read<AuthCubit>().login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: Wrap(
                                children: [
                                  Text(isAr ? 'ليس لديك حساب؟ ' : "Don't have an account? ",
                                      style: AppTextStyles.body(context)),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
                                    child: Text(
                                      isAr ? 'إنشاء حساب' : 'Sign Up',
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
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
