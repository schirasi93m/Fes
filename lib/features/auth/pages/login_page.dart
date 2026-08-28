import 'package:flutter/material.dart';

import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_shadows.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/dashboard/main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.dialog),
                  boxShadow: AppShadows.card,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          AppIcons.extinguisher,
                          color: AppColors.primary,
                          size: 38,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        'به ایمن شهر خوش آمدید',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'برای ورود به سامانه، اطلاعات حساب خود را وارد کنید.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        controller: _usernameController,
                        label: 'نام کاربری',
                        hint: 'نام کاربری خود را وارد کنید',
                        requiredField: true,
                        prefixIcon: const Icon(AppIcons.user),
                        validator: (value) => value == null || value.trim().isEmpty
                            ? 'نام کاربری را وارد کنید.'
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _passwordController,
                        label: 'رمز عبور',
                        hint: 'رمز عبور خود را وارد کنید',
                        requiredField: true,
                        obscureText: _obscurePassword,
                        prefixIcon: const Icon(AppIcons.lock),
                        suffixIcon: IconButton(
                          tooltip: _obscurePassword
                              ? 'نمایش رمز عبور'
                              : 'پنهان کردن رمز عبور',
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          icon: Icon(
                            _obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
                          ),
                        ),
                        validator: (value) => value == null || value.isEmpty
                            ? 'رمز عبور را وارد کنید.'
                            : null,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => AppNotifier.info(
                            context,
                            'برای بازیابی رمز عبور با مدیر سیستم تماس بگیرید.',
                          ),
                          child: const Text('رمز عبور را فراموش کرده‌اید؟'),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton(
                        text: 'ورود به سامانه',
                        icon: AppIcons.login,
                        onPressed: _login,
                        size: AppButtonSize.large,
                        width: double.infinity,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
