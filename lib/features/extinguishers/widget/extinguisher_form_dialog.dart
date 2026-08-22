import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:new_project_fes/core/enums/entity_state.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_number_field.dart';
import 'package:new_project_fes/core/widgets/app_selector.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/core/widgets/persian_calendar_picker.dart';
import 'package:new_project_fes/core/widgets/status_toggle.dart';
import 'package:new_project_fes/features/code_title/models/code_title_model.dart';
import 'package:new_project_fes/features/code_title/repository/code_title_repository_api.dart';
import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/repository/customer_repository_api.dart';
import 'package:new_project_fes/features/customers/widgets/customer_form_dialog.dart';
import 'package:new_project_fes/features/extinguishers/controllers/extinguisher_controller.dart';
import 'package:new_project_fes/features/extinguishers/models/extinguishers_model.dart';

class ExtinguisherDialog extends StatefulWidget {
  final ExtinguisherModel? extinguisher;
  final ExtinguisherController controller;
  final VoidCallback? onCustomersPressed;
  final ValueChanged<CustomerModel>? onCustomerEdit;

  const ExtinguisherDialog({
    super.key,
    required this.controller,
    this.extinguisher,
    this.onCustomersPressed,
    this.onCustomerEdit,
  });

  static Future<ExtinguisherModel?> show(
    BuildContext context, {
    required ExtinguisherController controller,
    ExtinguisherModel? extinguisher,
    VoidCallback? onCustomersPressed,
    ValueChanged<CustomerModel>? onCustomerEdit,
  }) {
    return showDialog<ExtinguisherModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ExtinguisherDialog(
        controller: controller,
        extinguisher: extinguisher,
        onCustomersPressed: onCustomersPressed,
        onCustomerEdit: onCustomerEdit,
      ),
    );
  }

  @override
  State<ExtinguisherDialog> createState() => _ExtinguisherDialogState();
}

class _ExtinguisherDialogState extends State<ExtinguisherDialog> {
  // CategoryId مربوط به «نوع کپسول» در جدول CodeTitle
  static const int _extinguisherTypeCategoryId = 2;

  late final TextEditingController serialNumberController;
  late final TextEditingController capacityController;
  late final TextEditingController locationController;

  final CustomerRepositoryApi _customerRepository = CustomerRepositoryApi(
    ApiClient(),
  );

  final CodeTitleRepositoryApi _codeTitleRepository = CodeTitleRepositoryApi(
    ApiClient(),
  );

  List<CustomerModel> _customers = [];
  List<CodeTitleModel> _types = [];

  bool _isLoadingCustomers = true;
  bool _isLoadingTypes = true;

  // وقتی true باشد، درخواست ثبت/ویرایش در حال ارسال به بک‌اند است.
  // Dialog تا مشخص شدن نتیجه (موفق یا ناموفق) بسته نمی‌شود.
  bool _isSubmitting = false;

  int? selectedCustomerId;
  int? selectedTypeId;

  DateTime? productionDate;
  DateTime? lastServiceDate;
  DateTime? nextServiceDate;

  bool isActive = true;

  bool get isEditMode => widget.extinguisher != null;

  @override
  void initState() {
    super.initState();

    final extinguisher = widget.extinguisher;

    serialNumberController = TextEditingController(
      text: extinguisher?.serialNumber ?? '',
    );

    capacityController = TextEditingController(
      text: extinguisher?.capacity.toString() ?? '',
    );

    locationController = TextEditingController(
      text: extinguisher?.location ?? '',
    );

    selectedCustomerId = extinguisher?.customerId;
    selectedTypeId = extinguisher?.typeId;

    productionDate = extinguisher?.productionDate;
    lastServiceDate = extinguisher?.lastServiceDate;
    nextServiceDate = extinguisher?.nextServiceDate;

    isActive = extinguisher?.isActive ?? true;

    _loadCustomers();
    _loadTypes();
  }

  @override
  void dispose() {
    serialNumberController.dispose();
    capacityController.dispose();
    locationController.dispose();

    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _customerRepository.getList();

      if (!mounted) {
        return;
      }

      setState(() {
        _customers = customers;
        _isLoadingCustomers = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingCustomers = false;
      });

      AppNotifier.error(context, 'دریافت لیست مشتریان با خطا مواجه شد.');
    }
  }

  Future<void> _loadTypes() async {
    try {
      final types = await _codeTitleRepository.getByCategoryId(
        _extinguisherTypeCategoryId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _types = types;
        _isLoadingTypes = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoadingTypes = false;
      });

      AppNotifier.error(context, 'دریافت لیست نوع کپسول با خطا مواجه شد.');
    }
  }

  /// پیام خطای قابل‌فهم برای کاربر را از خطای دریافتی استخراج می‌کند.
  /// اگر بک‌اند پیام اعتبارسنجی مشخصی برگردانده باشد، همان نمایش داده می‌شود.
  String _extractErrorMessage(Object error) {
    if (error is DioException) {
      final response = error.response;

      if (response == null) {
        return 'ارتباط با سرور برقرار نشد. اتصال شبکه یا آدرس API را بررسی کنید.';
      }

      final data = response.data;

      if (data is Map) {
        // فرمت رایج ValidationProblemDetails در ASP.NET Core
        final errors = data['errors'];
        if (errors is Map && errors.isNotEmpty) {
          final firstKey = errors.keys.first;
          final firstValue = errors[firstKey];
          if (firstValue is List && firstValue.isNotEmpty) {
            return firstValue.first.toString();
          }
        }

        final title = data['title'] ?? data['message'] ?? data['detail'];
        if (title != null && title.toString().trim().isNotEmpty) {
          return title.toString();
        }
      } else if (data is String && data.trim().isNotEmpty) {
        return data;
      }

      return 'خطای سرور (کد ${response.statusCode}). ${isEditMode ? 'ویرایش' : 'ثبت'} کپسول انجام نشد.';
    }

    return '${isEditMode ? 'ویرایش' : 'ثبت'} کپسول با خطا مواجه شد.';
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    final serialNumber = serialNumberController.text.trim();
    final capacityText = capacityController.text.trim();
    final location = locationController.text.trim();

    final customerId = selectedCustomerId;
    final typeId = selectedTypeId;

    if (serialNumber.isEmpty) {
      AppNotifier.warning(context, 'شماره سریال را وارد کنید.');
      return;
    }

    if (typeId == null) {
      AppNotifier.warning(context, 'نوع کپسول را انتخاب کنید.');
      return;
    }

    final capacity = double.tryParse(capacityText);

    if (capacity == null) {
      AppNotifier.warning(context, 'ظرفیت نامعتبر است.');
      return;
    }

    if (customerId == null) {
      AppNotifier.warning(context, 'مشتری را انتخاب کنید.');
      return;
    }

    if (productionDate == null) {
      AppNotifier.warning(context, 'تاریخ تولید را انتخاب کنید.');
      return;
    }

    if (lastServiceDate == null) {
      AppNotifier.warning(context, 'تاریخ آخرین سرویس را انتخاب کنید.');
      return;
    }

    if (nextServiceDate == null) {
      AppNotifier.warning(context, 'تاریخ سرویس بعدی را انتخاب کنید.');
      return;
    }

    final oldExtinguisher = widget.extinguisher;

    final extinguisher = ExtinguisherModel(
      id: oldExtinguisher?.id,
      serialNumber: serialNumber,
      typeId: typeId,
      capacity: capacity,
      location: location,
      customerId: customerId,
      productionDate: productionDate!,
      lastServiceDate: lastServiceDate!,
      nextServiceDate: nextServiceDate!,
      isActive: isActive,
      entityState: isEditMode ? EntityState.modified : EntityState.inserted,
    );

    setState(() {
      _isSubmitting = true;
    });

    try {
      final savedExtinguisher = isEditMode
          ? await widget.controller.update(extinguisher)
          : await widget.controller.add(extinguisher);

      if (!mounted) {
        return;
      }

      // فقط در صورت موفقیت واقعی درخواست، Dialog بسته می‌شود.
      Navigator.pop(context, savedExtinguisher);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      // Dialog عمداً بسته نمی‌شود تا کاربر اطلاعات واردشده را از دست ندهد.
      AppNotifier.error(context, _extractErrorMessage(e));
    }
  }

  Widget _formRow({required Widget first, required Widget second}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        const SizedBox(width: AppSpacing.md),
        Expanded(child: second),
      ],
    );
  }

  Widget _buildCustomerField() {
    if (_isLoadingCustomers) {
      return const SizedBox(
        height: AppSizes.textFieldHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AppSelector<CustomerModel>(
      label: 'مشتری',
      hint: 'مشتری را انتخاب کنید',
      requiredField: true,
      value: _customers.cast<CustomerModel?>().firstWhere(
        (customer) => customer?.id == selectedCustomerId,
        orElse: () => null,
      ),
      items: _customers,
      itemLabel: (customer) => customer.fullName,
      secondaryItemLabel: (customer) => customer.code.toString(),
      primaryHeader: 'عنوان',
      secondaryHeader: 'کد',
      searchable: true,
      searchHint: 'جستجوی مشتری...',
      showAddButton: true,
      showEditButton: true,
      onAddPressed: widget.onCustomersPressed == null ? null : _openCustomers,
      onEditPressed: widget.onCustomerEdit == null ? null : _openCustomerEdit,
      enabled: !_isSubmitting,
      onChanged: (customer) {
        setState(() {
          selectedCustomerId = customer?.id;
        });
      },
    );
  }

  void _openCustomers() {
    if (_isSubmitting) {
      return;
    }

    Navigator.of(context).pop();
    widget.onCustomersPressed?.call();
  }

  Future<void> _openCustomerEdit() async {
    if (_isSubmitting || selectedCustomerId == null) {
      return;
    }

    final customer = _customers.cast<CustomerModel?>().firstWhere(
      (item) => item?.id == selectedCustomerId,
      orElse: () => null,
    );

    if (customer == null) {
      return;
    }

    final updatedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (updatedCustomer == null || !mounted) {
      return;
    }

    setState(() {
      _customers = _customers.map((item) {
        if (item.id == updatedCustomer.id) {
          return updatedCustomer;
        }
        return item;
      }).toList();
      selectedCustomerId = updatedCustomer.id;
    });

    AppNotifier.success(context, 'اطلاعات مشتری با موفقیت ویرایش شد.');
  }

  Widget _buildTypeField() {
    if (_isLoadingTypes) {
      return const SizedBox(
        height: AppSizes.textFieldHeight,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AppSelector<CodeTitleModel>(
      label: 'نوع کپسول',
      secondaryItemLabel: (type) => type.code.toString(),
      hint: 'نوع کپسول را انتخاب کنید',
      requiredField: true,
      value: _types.cast<CodeTitleModel?>().firstWhere(
        (type) => type?.id == selectedTypeId,
        orElse: () => null,
      ),
      items: _types,
      itemLabel: (type) => type.title,
      primaryHeader: 'عنوان',
      secondaryHeader: 'کد',
      searchable: true,
      searchHint: 'جستجوی نوع کپسول...',
      showAddButton: false,
      showEditButton: false,
      enabled: !_isSubmitting,
      onChanged: (type) {
        setState(() {
          selectedTypeId = type?.id;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: AlertDialog(
        backgroundColor: AppColors.surface,

        title: Text(isEditMode ? 'ویرایش کپسول' : 'کپسول جدید'),

        content: SizedBox(
          width: AppSizes.dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ردیف اول
                _formRow(
                  first: _buildCustomerField(),
                  second: _buildTypeField(),
                ),

                const SizedBox(height: AppSpacing.md),

                // ردیف دوم
                _formRow(
                  first: AppTextField(
                    requiredField: true,
                    controller: serialNumberController,
                    label: 'شماره سریال',
                    enabled: !_isSubmitting,
                  ),

                  second: AppNumberField(
                    requiredField: true,
                    controller: capacityController,
                    label: 'ظرفیت',
                    min: 0,
                    step: 1,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ردیف سوم
                _formRow(
                  first: MyPersianCalendar(
                    label: 'تاریخ تولید',
                    requiredField: true,
                    value: productionDate,
                    onChanged: (date) {
                      setState(() {
                        productionDate = date;
                      });
                    },
                  ),

                  second: MyPersianCalendar(
                    label: 'تاریخ سرویس بعدی',
                    requiredField: true,
                    value: nextServiceDate,
                    onChanged: (date) {
                      setState(() {
                        nextServiceDate = date;
                      });
                    },
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // ردیف چهارم
                AppTextField(
                  requiredField: false,
                  controller: locationController,
                  label: 'محل استقرار',
                  enabled: !_isSubmitting,
                ),

                const SizedBox(height: AppSpacing.md),

                // ردیف پنجم
                _formRow(
                  first: MyPersianCalendar(
                    label: 'تاریخ آخرین سرویس',
                    requiredField: true,
                    value: lastServiceDate,
                    onChanged: (date) {
                      setState(() {
                        lastServiceDate = date;
                      });
                    },
                  ),

                  second: StatusToggle(
                    value: isActive,
                    title: 'وضعیت کپسول',
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

        actions: [
          AppButton(
            text: 'انصراف',
            type: AppButtonType.filled,
            enabled: !_isSubmitting,
            onPressed: () {
              Navigator.pop(context);
            },
          ),

          AppButton(
            text: isEditMode ? 'ذخیره تغییرات' : 'ثبت',
            isLoading: _isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
