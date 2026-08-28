import 'package:flutter/material.dart';

import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/core/widgets/status_toggle.dart';
import 'package:new_project_fes/features/users/models/app_user_model.dart';

class UserFormDialog extends StatefulWidget {
  final AppUserModel? user;

  const UserFormDialog({super.key, this.user});

  static Future<AppUserModel?> show(BuildContext context, {AppUserModel? user}) {
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
  bool _isActive = true;

  bool get _isEditing => widget.user != null;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _usernameController = TextEditingController(text: user?.username ?? '');
    _roleController = TextEditingController(text: user?.role ?? 'کاربر');
    _isActive = user?.isActive ?? true;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final user = widget.user;
    Navigator.pop(
      context,
      AppUserModel(
        id: user?.id ?? DateTime.now().microsecondsSinceEpoch,
        fullName: _fullNameController.text.trim(),
        username: _usernameController.text.trim(),
        role: _roleController.text.trim(),
        isActive: _isActive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'ویرایش کاربر' : 'کاربر جدید'),
      content: SizedBox(
        width: AppSizes.responsiveDialogWidth(context, maxWidth: 520),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                controller: _fullNameController,
                label: 'نام و نام خانوادگی',
                requiredField: true,
                prefixIcon: const Icon(AppIcons.user),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'نام کاربر را وارد کنید.'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _usernameController,
                label: 'نام کاربری',
                requiredField: true,
                prefixIcon: const Icon(AppIcons.login),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'نام کاربری را وارد کنید.'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppTextField(
                controller: _roleController,
                label: 'نقش کاربر',
                requiredField: true,
                prefixIcon: const Icon(AppIcons.key),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'نقش کاربر را وارد کنید.'
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              StatusToggle(
                value: _isActive,
                title: 'وضعیت حساب',
                onChanged: (value) => setState(() => _isActive = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        AppButton(
          text: 'انصراف',
          type: AppButtonType.outlined,
          onPressed: () => Navigator.pop(context),
        ),
        AppButton(text: _isEditing ? 'ذخیره تغییرات' : 'ثبت کاربر', onPressed: _save),
      ],
    );
  }
}
