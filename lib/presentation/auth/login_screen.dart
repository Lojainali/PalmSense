import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/routes/app_router.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/custom_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../logic/auth/auth_cubit.dart';
import '../../logic/auth/auth_state.dart';

/// Screen: Login ("Welcome back")
/// Redirects:
///  - Sign In (success)      -> AppRoutes.mainShell (pushReplacement)
///  - "Forgot password?"     -> AppRoutes.forgotPassword (push)
///  - "Don't have an account? Sign Up" -> AppRoutes.signUp (push)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'sara.ahmed@palmfarm.ae');
  final _passwordController = TextEditingController(text: 'palmfarm123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                    decoration: BoxDecoration(
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
                                color: Colors.white.withOpacity(0.15),
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
                        const Text(
                          'AI-powered fungal disease detection for date palms',
                          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome back', style: AppTextStyles.heading(context, size: 24)),
                        const SizedBox(height: 6),
                        Text('Sign in to your account',
                            style: AppTextStyles.caption(context, size: 14)),
                        const SizedBox(height: 24),
                        CustomTextField(
                          label: 'Email Address',
                          hint: 'sara.ahmed@palmfarm.ae',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),
                        CustomTextField(
                          label: 'Password',
                          hint: '••••••••••',
                          controller: _passwordController,
                          obscureText: true,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed(AppRoutes.forgotPassword),
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: isDark ? AppColors.accent : AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        PrimaryButton(
                          label: 'Sign In',
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
                              Text("Don't have an account? ", style: AppTextStyles.body(context)),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pushNamed(AppRoutes.signUp),
                                child: Text(
                                  'Sign Up',
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
  }
}
