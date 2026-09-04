import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:new_project_fes/core/network/api_client.dart';
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
import 'package:new_project_fes/features/auth/model/login_request_model.dart';
import 'package:new_project_fes/features/auth/repository/auth_repository_api.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  late final AuthRepositoryApi _authRepository;

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _authRepository = AuthRepositoryApi(ApiClient());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _login() async {
    // Validation فرم
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // جلوگیری از ارسال چند درخواست همزمان
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequestModel(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final user = await _authRepository.login(request);

      debugPrint('========== LOGIN SUCCESS ==========');
      debugPrint('User Id: ${user.id}');
      debugPrint('Full Name: ${user.fullName}');
      debugPrint('Username: ${user.username}');
      debugPrint('Role: ${user.role}');
      debugPrint('===================================');

      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      // ورود موفق
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => MainScreen(user: user)));
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      final message = _extractLoginErrorMessage(e);

      AppNotifier.error(context, message);
    }
  }

  String _extractLoginErrorMessage(Object error) {
    if (error is DioException) {
      final response = error.response;

      // سرور هیچ پاسخی نداده
      if (response == null) {
        debugPrint('========== LOGIN ERROR ==========');
        debugPrint('No response from server');
        debugPrint('Error: ${error.message}');
        debugPrint('Type: ${error.type}');
        debugPrint('Request URL: ${error.requestOptions.uri}');
        debugPrint('=================================');

        return 'ارتباط با سرور برقرار نشد. اتصال شبکه یا آدرس API را بررسی کنید.';
      }

      final data = response.data;

      // اطلاعات کامل خطا برای Debug Console
      debugPrint('========== LOGIN ERROR ==========');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Request URL: ${response.requestOptions.uri}');
      debugPrint('Response Data: $data');
      debugPrint('Response Headers: ${response.headers}');
      debugPrint('=================================');

      // Username یا Password اشتباه
      if (response.statusCode == 401) {
        return 'نام کاربری یا رمز عبور اشتباه است.';
      }

      // Bad Request
      if (response.statusCode == 400) {
        if (data is Map) {
          final message = data['message'] ?? data['title'] ?? data['detail'];

          if (message != null && message.toString().trim().isNotEmpty) {
            return message.toString();
          }
        }

        return 'اطلاعات ورود نامعتبر است.';
      }

      // سایر خطاهایی که Backend پیام ارسال کرده
      if (data is Map) {
        final message = data['message'] ?? data['title'] ?? data['detail'];

        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }

      return '''
خطایی در ورود به سامانه رخ داد.

کد خطا: ${response.statusCode}
''';
    }

    // خطای غیر از Dio
    debugPrint('========== LOGIN UNKNOWN ERROR ==========');
    debugPrint('Error: $error');
    debugPrint('Type: ${error.runtimeType}');
    debugPrint('========================================');

    return 'خطای نامشخصی هنگام ورود رخ داد.';
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'نام کاربری را وارد کنید.';
                          }

                          return null;
                        },
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
                          onPressed: _isLoading
                              ? null
                              : () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                          icon: Icon(
                            _obscurePassword ? AppIcons.eye : AppIcons.eyeOff,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'رمز عبور را وارد کنید.';
                          }

                          return null;
                        },
                      ),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  AppNotifier.info(
                                    context,
                                    'برای بازیابی رمز عبور با مدیر سیستم تماس بگیرید.',
                                  );
                                },
                          child: const Text('رمز عبور را فراموش کرده‌اید؟'),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      AppButton(
                        text: 'ورود به سامانه',
                        icon: AppIcons.login,
                        onPressed: _isLoading ? null : _login,
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
