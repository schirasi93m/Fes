import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';

import '../models/customer_model.dart';

class CustomerDialog extends StatefulWidget {
  const CustomerDialog({super.key});

  static Future<CustomerModel?> show(BuildContext context) {
    return showDialog<CustomerModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const CustomerDialog(),
    );
  }

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _submit() {
    final customer = CustomerModel(
      fullName: fullNameController.text.trim(),
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
    );

    Navigator.of(context).pop(customer);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text("مشتری جدید"),
      content: SizedBox(
        width: AppSizes.dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(controller: fullNameController, label: "نام کامل"),
            const SizedBox(height: AppSpacing.md),
            AppTextField(
              controller: phoneController,
              label: "شماره تماس",
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            AppTextField(
              controller: addressController,
              label: "آدرس",
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        AppButton(
          text: "انصراف",
          type: AppButtonType.filled,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        AppButton(text: "ثبت", onPressed: _submit),
      ],
    );
  }
}
