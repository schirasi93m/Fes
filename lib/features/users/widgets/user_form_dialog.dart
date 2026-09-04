import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/core/widgets/status_toggle.dart';
import 'package:new_project_fes/features/users/models/app_user_model.dart';
import 'package:new_project_fes/features/users/repository/user_repository_api.dart';

class UserFormDialog extends StatefulWidget {
  final AppUserModel? user;

  const UserFormDialog({super.key, this.user});

  static Future<AppUserModel?> show(
    BuildContext context, {
    AppUserModel? user,
  }) {
    return showDialog<AppUserModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => UserFormDialog(user: user),
    );
  }

  @override
  State<UserFormDialog> createState() => _UserFormDialogState();
}

class _UserFormDialogState extends State<UserFormDialog> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _fullNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _roleController;
  late final TextEditingController _passwordController;

  late final UserRepositoryApi _userRepository;

  bool _isActive = true;
  bool _isSubmitting = false;
  bool _isInitializationFailed = false;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();

    debugPrint('[UserFormDialog.initState] شروع');
    try {
      _userRepository = UserRepositoryApi(ApiClient());
      debugPrint('[UserFormDialog.initState] UserRepositoryApi ایجاد شد');
    } catch (e) {
      debugPrint('[UserFormDialog.initState] خطا در UserRepositoryApi: $e');
      _isInitializationFailed = true;
    }

    try {
      final user = widget.user;
      debugPrint('[UserFormDialog.initState] user model: ${user?.fullName}');
      _fullNameController = TextEditingController(text: user?.fullName ?? '');
      _usernameController = TextEditingController(text: user?.username ?? '');
      _passwordController = TextEditingController();
      _roleController = TextEditingController(text: user?.role ?? 'کاربر');
      _isActive = user?.isActive ?? true;
      debugPrint('[UserFormDialog.initState] controllers ایجاد شدند');
    } catch (e) {
      debugPrint('[UserFormDialog.initState] خطا در controllers: $e');
      _isInitializationFailed = true;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_isInitializationFailed) {
      if (mounted) {
        AppNotifier.error(context, 'خطایی در بارگذاری فرم رخ داد.');
      }
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    if (_isSubmitting) {
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      debugPrint('[UserForm] ایجاد user model...');
      final user = AppUserModel(
        id: widget.user?.id,
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        role: _roleController.text.trim(),
        isActive: _isActive,
      );
      debugPrint('[UserForm] user model ایجاد شد: ${user.fullName}');

      debugPrint('[UserForm] ارسال به API (_isEditing=$_isEditing)...');
      final result = _isEditing
          ? await _userRepository.update(user)
          : await _userRepository.insert(user);
      debugPrint('[UserForm] API پاسخ داد: ${result.fullName}');

      if (mounted) {
        Navigator.pop(context, result);
      }
    } on SocketException catch (e) {
      debugPrint('[UserForm] خطای شبکه: $e');
      if (mounted) {
        setState(() => _isSubmitting = false);
        AppNotifier.error(context, 'بدون اتصال اینترنت');
      }
    } catch (e) {
      debugPrint('[UserForm] خطا: $e (نوع: ${e.runtimeType})');
      if (mounted) {
        setState(() => _isSubmitting = false);
        final errorMessage = _extractErrorMessage(e);
        AppNotifier.error(context, errorMessage);
      }
    }
  }

  String _extractErrorMessage(Object error) {
    debugPrint('[ErrorHandler] خطا نوع: ${error.runtimeType}');

    if (error is DioException) {
      debugPrint('[ErrorHandler] DioException: ${error.message}');
      final response = error.response;

      if (response == null) {
        debugPrint('[ErrorHandler] response null است - شاید شبکه قطع شده');
        return 'ارتباط با سرور برقرار نشد. اتصال شبکه یا آدرس API را بررسی کنید.';
      }

      debugPrint('[ErrorHandler] status code: ${response.statusCode}');
      debugPrint('[ErrorHandler] response data: ${response.data}');

      final data = response.data;

      if (data is Map) {
        // ValidationProblemDetails from ASP.NET Core
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstValue = errors[firstKey];
          if (firstValue is List && firstValue.isNotEmpty) {
            final msg = firstValue.first.toString();
            debugPrint('[ErrorHandler] validation error: $msg');
            return msg;
          }
        }

        // Generic error message
        final title = data['title'] ?? data['message'] ?? data['detail'];
        if (title != null && title.toString().trim().isNotEmpty) {
          final msg = title.toString();
          debugPrint('[ErrorHandler] title error: $msg');
          return msg;
        }
      }

      // Status code specific errors
      if (response.statusCode == 409) {
        return 'نام کاربری وارد شده قبلاً استفاده شده است.';
      }

      if (response.statusCode == 400) {
        return 'اطلاعات ارسالی معتبر نیست.';
      }

      if (response.statusCode == 401) {
        return 'احراز هویت ناکام. دوباره وارد شوید.';
      }

      if (response.statusCode == 403) {
        return 'دسترسی محدود است.';
      }

      if (response.statusCode == 500) {
        return 'خطای سرور. لطفاً بعداً دوباره سعی کنید.';
      }

      return 'خطایی در ارتباط با سرور رخ داد: ${response.statusCode}';
    }

    // Generic error
    final msg = error.toString();
    debugPrint('[ErrorHandler] generic error: $msg');
    return 'خطا: $msg';
  }

  String? _validatePassword(String? value) {
    try {
      final password = value?.trim() ?? '';

      // هنگام ایجاد کاربر، Password اجباری است.
      if (!_isEditing) {
        if (password.isEmpty) {
          return 'رمز عبور را وارد کنید.';
        }

        if (password.length < 6) {
          return 'رمز عبور باید حداقل ۶ کاراکتر باشد.';
        }

        return null;
      }

      // هنگام ویرایش، Password اختیاری است.
      if (password.isEmpty) {
        return null;
      }

      if (password.length < 6) {
        return 'رمز عبور باید حداقل ۶ کاراکتر باشد.';
      }

      return null;
    } catch (e) {
      debugPrint('خطا در _validatePassword: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      title: Text(_isEditing ? 'ویرایش کاربر' : 'کاربر جدید'),
      content: SizedBox(
        width: AppSizes.responsiveDialogWidth(context, maxWidth: 520),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // نمایش خطا در صورت مشکل initialization
                if (_isInitializationFailed)
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    margin: const EdgeInsets.only(bottom: AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.dangerBackground,
                      border: Border.all(color: AppColors.danger),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: AppColors.danger,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'خطایی در بارگذاری فرم رخ داد.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.danger),
                          ),
                        ),
                      ],
                    ),
                  ),
                AppTextField(
                  controller: _fullNameController,
                  label: 'نام و نام خانوادگی',
                  requiredField: true,
                  prefixIcon: const Icon(AppIcons.user),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'نام کاربر را وارد کنید.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _usernameController,
                  label: 'نام کاربری',
                  requiredField: true,
                  prefixIcon: const Icon(AppIcons.login),
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
                  label: _isEditing ? 'رمز عبور جدید' : 'رمز عبور',
                  requiredField: !_isEditing,
                  prefixIcon: const Icon(AppIcons.password),
                  obscureText: true,
                  validator: _validatePassword,
                ),
                if (_isEditing)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.xs),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'برای تغییر رمز عبور، رمز جدید را وارد کنید.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _roleController,
                  label: 'نقش کاربر',
                  requiredField: true,
                  prefixIcon: const Icon(AppIcons.shieldUser),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'نقش کاربر را وارد کنید.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                StatusToggle(
                  value: _isActive,
                  title: 'وضعیت حساب',
                  onChanged: (value) {
                    setState(() => _isActive = value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        AppButton(
          text: 'انصراف',
          type: AppButtonType.outlined,
          onPressed: () => Navigator.pop(context),
        ),
        AppButton(
          text: _isEditing ? 'ذخیره تغییرات' : 'ثبت کاربر',
          onPressed: _isSubmitting || _isInitializationFailed ? null : _save,
        ),
      ],
    );
  }
}
