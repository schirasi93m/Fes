import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/core/widgets/status_toggle.dart';

import '../models/customer_model.dart';

class CustomerDialog extends StatefulWidget {
  final CustomerModel? customer;

  const CustomerDialog({super.key, this.customer});

  static Future<CustomerModel?> show(
    BuildContext context, {
    CustomerModel? customer,
  }) {
    return showDialog<CustomerModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => CustomerDialog(customer: customer),
    );
  }

  @override
  State<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<CustomerDialog> {
  final TextEditingController codeController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isActive = true;

  bool get isEditMode => widget.customer != null;

  @override
  void initState() {
    super.initState();

    final customer = widget.customer;

    if (customer != null) {
      codeController.text = customer.code.toString();
      fullNameController.text = customer.fullName;
      phoneController.text = customer.phone;
      addressController.text = customer.address;
      isActive = customer.isActive;
    }
  }

  @override
  void dispose() {
    codeController.dispose();
    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void _submit() {
    final code = int.tryParse(codeController.text.trim());
    final fullName = fullNameController.text.trim();
    final phone = phoneController.text.trim();
    final address = addressController.text.trim();

    if (code == null) {
      AppNotifier.warning(context, "کد مشتری را وارد کنید.");
      return;
    }

    if (fullName.isEmpty) {
      AppNotifier.warning(context, "نام مشتری را وارد کنید.");
      return;
    }

    if (phone.isEmpty) {
      AppNotifier.warning(context, "شماره تماس را وارد کنید.");
      return;
    }

    if (phone.length != 11) {
      AppNotifier.warning(context, "شماره تماس باید ۱۱ رقم باشد.");
      return;
    }

    final oldCustomer = widget.customer;

    final customer = CustomerModel(
      id: oldCustomer?.id,
      code: code,
      fullName: fullName,
      phone: phone,
      address: address,
      isActive: isActive,
    );

    Navigator.pop(context, customer);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,

      title: Text(isEditMode ? "ویرایش مشتری" : "مشتری جدید"),

      content: SizedBox(
        width: AppSizes.responsiveDialogWidth(context),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField(
              requiredField: true,
              controller: codeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              label: "کد مشتری",
            ),
            const SizedBox(height: AppSpacing.md),
            AppTextField(requiredField: true,controller: fullNameController, label: "نام کامل"),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              requiredField: true,
              controller: phoneController,
              label: "شماره تماس",
              keyboardType: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),

            const SizedBox(height: AppSpacing.md),

            AppTextField(
              requiredField: true,
              controller: addressController,
              label: "آدرس",
              maxLines: 3,
            ),

            const SizedBox(height: AppSpacing.md),

            StatusToggle(
              value: isActive,
              title: 'وضعیت',
              onChanged: (value) {
                setState(() {
                  isActive = value;
                });
              },
            ),
          ],
        ),
      ),

      actions: [
        AppButton(
          text: "انصراف",
          type: AppButtonType.filled,
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        AppButton(
          text: isEditMode ? "ذخیره تغییرات" : "ثبت",
          onPressed: _submit,
        ),
      ],
    );
  }
}
