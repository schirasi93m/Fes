import 'package:flutter/material.dart';

import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_checkbox.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
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
import 'package:new_project_fes/features/extinguishers/repository/extinguisher_repository_api.dart';
import 'package:new_project_fes/features/extinguishers/widget/extinguisher_form_dialog.dart';

import 'package:new_project_fes/features/services/model/service_model.dart';
import 'package:new_project_fes/features/services/repository/services_api.dart';

class ServiceDialog extends StatefulWidget {
  const ServiceDialog({super.key});

  static Future<ServiceModel?> show(BuildContext context) {
    return showDialog<ServiceModel>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const ServiceDialog(),
    );
  }

  @override
  State<ServiceDialog> createState() => _ServiceDialogState();
}

class _ServiceDialogState extends State<ServiceDialog> {
  final CustomerRepositoryApi _customerRepository = CustomerRepositoryApi(
    ApiClient(),
  );

  final ExtinguisherRepositoryApi _extinguisherRepository =
      ExtinguisherRepositoryApi(ApiClient());

  final ExtinguisherController _extinguisherController = ExtinguisherController(
    ExtinguisherRepositoryApi(ApiClient()),
  );

  final CodeTitleRepositoryApi _codeTitleRepository = CodeTitleRepositoryApi(
    ApiClient(),
  );

  final ServiceApi _serviceApi = ServiceApi(ApiClient());

  List<CustomerModel> _customers = [];
  List<ExtinguisherModel> _extinguishers = [];
  List<CodeTitleModel> _extinguisherTypes = [];

  CustomerModel? _selectedCustomer;
  ExtinguisherModel? _selectedExtinguisher;

  final TextEditingController _descriptionController = TextEditingController();

  DateTime? _serviceDate;
  DateTime? _nextServiceDate;

  bool _isActive = true;

  bool _needsValve = false;
  bool _needsGauge = false;
  bool _needsPipe = false;
  bool _needsPowder = false;
  bool _needsHose = false;

  bool _isLoading = true;
  bool _isSubmitting = false;

  List<ExtinguisherModel> get _customerExtinguishers {
    final customerId = _selectedCustomer?.id;

    if (customerId == null) {
      return [];
    }

    return _extinguishers
        .where((extinguisher) => extinguisher.customerId == customerId)
        .toList();
  }

  String _extinguisherTypeName(ExtinguisherModel extinguisher) {
    for (final type in _extinguisherTypes) {
      if (type.id == extinguisher.typeId || type.code == extinguisher.typeId) {
        return type.title;
      }
    }

    return 'نوع نامشخص';
  }

  String _extinguisherSummary(ExtinguisherModel extinguisher) {
    final capacity = extinguisher.capacity % 1 == 0
        ? extinguisher.capacity.toInt().toString()
        : extinguisher.capacity.toString();

    final status = extinguisher.isActive ? 'فعال' : 'غیرفعال';

    return '${_extinguisherTypeName(extinguisher)} '
        '$capacity کیلویی | $status';
  }

  String _customerSummary(CustomerModel customer) {
    final extinguisherCount = _extinguishers
        .where((extinguisher) => extinguisher.customerId == customer.id)
        .length;

    return '${customer.code} | تعداد: $extinguisherCount';
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _customerRepository.getList(),
        _extinguisherRepository.getList(),
        _codeTitleRepository.getByCategoryId(2),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _customers = results[0] as List<CustomerModel>;

        _extinguishers = results[1] as List<ExtinguisherModel>;

        _extinguisherTypes = results[2] as List<CodeTitleModel>;

        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      AppNotifier.error(context, 'دریافت اطلاعات سرویس‌ها با خطا مواجه شد.');
    }
  }

  Future<void> _addCustomer() async {
    final customer = await CustomerDialog.show(context);

    if (customer == null) {
      return;
    }

    try {
      final savedCustomer = await _customerRepository.insert(customer);

      if (!mounted) {
        return;
      }

      setState(() {
        _customers = [..._customers, savedCustomer];

        _selectedCustomer = savedCustomer;
        _selectedExtinguisher = null;
      });

      AppNotifier.success(context, 'مشتری با موفقیت ثبت شد.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(
        context,
        'ثبت مشتری با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }

  Future<void> _editCustomer() async {
    final customer = _selectedCustomer;

    if (customer == null) {
      return;
    }

    final editedCustomer = await CustomerDialog.show(
      context,
      customer: customer,
    );

    if (editedCustomer == null) {
      return;
    }

    try {
      final savedCustomer = await _customerRepository.update(editedCustomer);

      if (!mounted) {
        return;
      }

      setState(() {
        _customers = _customers.map((item) {
          return item.id == savedCustomer.id ? savedCustomer : item;
        }).toList();

        _selectedCustomer = savedCustomer;
      });

      AppNotifier.success(context, 'اطلاعات مشتری با موفقیت ویرایش شد.');
    } catch (error) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(
        context,
        'ویرایش مشتری با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }

  Future<void> _addExtinguisher() async {
    final extinguisher = await ExtinguisherDialog.show(
      context,
      controller: _extinguisherController,
    );

    if (extinguisher == null) {
      return;
    }

    await _loadData();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCustomer = _customers.cast<CustomerModel?>().firstWhere(
        (customer) => customer?.id == extinguisher.customerId,
        orElse: () => null,
      );

      _selectedExtinguisher = _extinguishers
          .cast<ExtinguisherModel?>()
          .firstWhere(
            (item) => item?.id == extinguisher.id,
            orElse: () => null,
          );
    });

    AppNotifier.success(context, 'کپسول با موفقیت ثبت شد.');
  }

  Future<void> _editExtinguisher() async {
    final extinguisher = _selectedExtinguisher;

    if (extinguisher == null) {
      return;
    }

    final updatedExtinguisher = await ExtinguisherDialog.show(
      context,
      controller: _extinguisherController,
      extinguisher: extinguisher,
    );

    if (updatedExtinguisher == null) {
      return;
    }

    await _loadData();

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedCustomer = _customers.cast<CustomerModel?>().firstWhere(
        (customer) => customer?.id == updatedExtinguisher.customerId,
        orElse: () => null,
      );

      _selectedExtinguisher = _extinguishers
          .cast<ExtinguisherModel?>()
          .firstWhere(
            (item) => item?.id == updatedExtinguisher.id,
            orElse: () => null,
          );
    });

    AppNotifier.success(context, 'اطلاعات کپسول با موفقیت ویرایش شد.');
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    if (_selectedCustomer?.id == null) {
      AppNotifier.warning(context, 'مشتری را انتخاب کنید.');
      return;
    }

    if (_selectedExtinguisher?.id == null) {
      AppNotifier.warning(context, 'کپسول را انتخاب کنید.');
      return;
    }

    if (_serviceDate == null) {
      AppNotifier.warning(context, 'تاریخ سرویس را انتخاب کنید.');
      return;
    }

    if (_nextServiceDate == null) {
      AppNotifier.warning(context, 'تاریخ سرویس بعدی را انتخاب کنید.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final service = ServiceModel(
        customerId: _selectedCustomer!.id!,
        extinguisherId: _selectedExtinguisher!.id!,
        serviceDate: _serviceDate!,
        nextServiceDate: _nextServiceDate!,
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        needsValve: _needsValve,
        needsGauge: _needsGauge,
        needsPipe: _needsPipe,
        needsPowder: _needsPowder,
        needsHose: _needsHose,
      );

      final savedService = await _serviceApi.createService(service);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, savedService);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSubmitting = false;
      });

      AppNotifier.error(
        context,
        'ثبت سرویس با خطا مواجه شد. دوباره تلاش کنید.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),

      title: const Text('سرویس جدید'),

      content: SizedBox(
        width: AppSizes.responsiveDialogWidth(context),

        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(AppIcons.service, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'انتخاب اطلاعات سرویس',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    AppSelector<CustomerModel>(
                      label: 'مشتری',
                      hint: 'مشتری را انتخاب کنید',
                      requiredField: true,
                      value: _selectedCustomer,
                      items: _customers,
                      itemLabel: (customer) => customer.fullName,
                      secondaryItemLabel: _customerSummary,
                      primaryHeader: 'عنوان',
                      secondaryHeader: 'کد | تعداد کپسول',
                      searchable: true,
                      searchHint: 'جستجوی مشتری...',
                      showAddButton: true,
                      showEditButton: true,
                      onAddPressed: _addCustomer,
                      onEditPressed: _editCustomer,
                      onChanged: (customer) {
                        setState(() {
                          _selectedCustomer = customer;
                          _selectedExtinguisher = null;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppSelector<ExtinguisherModel>(
                      label: 'کپسول',
                      hint: _selectedCustomer == null
                          ? 'ابتدا مشتری را انتخاب کنید'
                          : 'کپسول را انتخاب کنید',
                      requiredField: true,
                      enabled: _selectedCustomer != null,
                      value: _selectedExtinguisher,
                      items: _customerExtinguishers,
                      itemLabel: (extinguisher) => extinguisher.serialNumber,
                      secondaryItemLabel: _extinguisherSummary,
                      primaryHeader: 'شماره سریال',
                      secondaryHeader: 'نوع | وضعیت کپسول',
                      searchable: true,
                      searchHint: 'جستجوی کپسول...',
                      showAddButton: true,
                      showEditButton: true,
                      onAddPressed: _addExtinguisher,
                      onEditPressed: _editExtinguisher,
                      onChanged: (extinguisher) {
                        setState(() {
                          _selectedExtinguisher = extinguisher;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final serviceDate = MyPersianCalendar(
                          label: 'تاریخ سرویس',
                          requiredField: true,
                          value: _serviceDate,
                          onChanged: (date) {
                            setState(() => _serviceDate = date);
                          },
                        );
                        final nextServiceDate = MyPersianCalendar(
                          label: 'تاریخ سرویس بعدی',
                          requiredField: true,
                          value: _nextServiceDate,
                          onChanged: (date) {
                            setState(() => _nextServiceDate = date);
                          },
                        );

                        if (constraints.maxWidth < AppSizes.formStackBreakpoint) {
                          return Column(
                            children: [
                              serviceDate,
                              const SizedBox(height: AppSpacing.md),
                              nextServiceDate,
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: serviceDate),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(child: nextServiceDate),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    AppTextField(
                      controller: _descriptionController,
                      label: 'توضیحات',
                      hint: 'توضیحات سرویس را وارد کنید',
                      maxLines: 3,
                    ),

                    const SizedBox(height: AppSpacing.md),

                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(AppRadius.card),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              AppSpacing.sm,
                              AppSpacing.md,
                              0,
                            ),
                            child: Text('موارد موردنیاز سرویس'),
                          ),

                          Wrap(
                            children: [
                              SizedBox(
                                width: AppSpacing.bigSpace,
                                child: AppCheckbox(
                                  value: _needsValve,
                                  label: 'شیر',
                                  onChanged: (value) {
                                    setState(() {
                                      _needsValve = value;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(
                                width: AppSpacing.bigSpace,
                                child: AppCheckbox(
                                  value: _needsGauge,
                                  label: 'درجه',
                                  onChanged: (value) {
                                    setState(() {
                                      _needsGauge = value;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(
                                width: AppSpacing.bigSpace,
                                child: AppCheckbox(
                                  value: _needsPipe,
                                  label: 'میل آب',
                                  onChanged: (value) {
                                    setState(() {
                                      _needsPipe = value;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(
                                width: AppSpacing.bigSpace,
                                child: AppCheckbox(
                                  value: _needsPowder,
                                  label: 'پودر',
                                  onChanged: (value) {
                                    setState(() {
                                      _needsPowder = value;
                                    });
                                  },
                                ),
                              ),

                              SizedBox(
                                width: AppSpacing.bigSpace,
                                child: AppCheckbox(
                                  value: _needsHose,
                                  label: 'شیلنگ',
                                  onChanged: (value) {
                                    setState(() {
                                      _needsHose = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.md),

                    StatusToggle(
                      value: _isActive,
                      title: 'وضعیت سرویس',
                      onChanged: (value) {
                        setState(() {
                          _isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
      ),

      actions: [
        AppButton(
          text: 'انصراف',
          type: AppButtonType.filled,
          onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        ),

        AppButton(text: 'ثبت', onPressed: _isSubmitting ? null : _submit),
      ],
    );
  }
}
