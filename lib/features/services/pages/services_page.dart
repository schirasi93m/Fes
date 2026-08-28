import 'package:flutter/material.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_date_utils.dart';
import 'package:new_project_fes/core/widgets/app_delete_dialog.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';

import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/repository/customer_repository_api.dart';

import 'package:new_project_fes/features/extinguishers/models/extinguishers_model.dart';
import 'package:new_project_fes/features/extinguishers/repository/extinguisher_repository_api.dart';

import 'package:new_project_fes/features/services/model/service_model.dart';
import 'package:new_project_fes/features/services/repository/services_api.dart';
import 'package:new_project_fes/features/services/wiget/service_form_dialog.dart';

class ServicesPage extends AppFormPage {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends AppFormPageState<ServicesPage> {
  final ServiceApi _serviceApi = ServiceApi(ApiClient());

  final CustomerRepositoryApi _customerRepository = CustomerRepositoryApi(
    ApiClient(),
  );

  final ExtinguisherRepositoryApi _extinguisherRepository =
      ExtinguisherRepositoryApi(ApiClient());

  List<ServiceModel> _services = [];

  List<CustomerModel> _customers = [];

  List<ExtinguisherModel> _extinguishers = [];

  // ------------------------------------------------------------
  // Page Settings
  // ------------------------------------------------------------

  @override
  String get pageTitle => 'سرویس‌ها';

  @override
  String get searchHint => 'جستجوی سرویس...';

  @override
  String get primaryButtonText => 'سرویس جدید';

  @override
  bool get showSearchBox => true;

  @override
  bool get showFilter => false;

  @override
  bool get showRefresh => true;

  @override
  bool get showEditAction => true;

  @override
  bool get showDeleteAction => true;

  // ------------------------------------------------------------
  // Columns
  // ------------------------------------------------------------

  @override
  List<AppTableColumn> get columns => const [
    AppTableColumn(title: 'شناسه', width: AppTableSizes.code),
    AppTableColumn(title: 'مشتری', width: AppTableSizes.name),
    AppTableColumn(title: 'کپسول', width: AppTableSizes.name),
    AppTableColumn(title: 'تاریخ سرویس', width: AppTableSizes.date),
    AppTableColumn(title: 'سرویس بعدی', width: AppTableSizes.date),
    AppTableColumn(title: 'موارد موردنیاز', width: AppTableSizes.name),
    AppTableColumn(title: 'عملیات', width: AppTableSizes.actions),
  ];

  // ------------------------------------------------------------
  // Load Data
  // ------------------------------------------------------------

  @override
  Future<void> loadData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final results = await Future.wait([
        _serviceApi.getServices(),
        _customerRepository.getList(),
        _extinguisherRepository.getList(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _services = results[0] as List<ServiceModel>;
        _customers = results[1] as List<CustomerModel>;
        _extinguishers = results[2] as List<ExtinguisherModel>;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      AppNotifier.error(context, 'دریافت اطلاعات سرویس‌ها با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Search
  // ------------------------------------------------------------

  @override
  void onSearchChanged(String value) {
    setState(() {});
  }

  List<ServiceModel> get _filteredServices {
    final query = _normalizeSearchText(searchController.text);

    if (query.isEmpty) {
      return _services;
    }

    return _services.where((service) {
      final customer = _getCustomer(service.customerId);

      final extinguisher = _getExtinguisher(service.extinguisherId);

      final customerName = customer?.fullName ?? '';

      final customerCode = customer?.code.toString() ?? '';

      final serialNumber = extinguisher?.serialNumber ?? '';

      return _normalizeSearchText(
            service.id?.toString() ?? '',
          ).contains(query) ||
          _normalizeSearchText(customerName).contains(query) ||
          _normalizeSearchText(customerCode).contains(query) ||
          _normalizeSearchText(serialNumber).contains(query) ||
          _normalizeSearchText(service.customerId.toString()).contains(query) ||
          _normalizeSearchText(
            service.extinguisherId.toString(),
          ).contains(query) ||
          _normalizeSearchText(_getRequestedItems(service)).contains(query);
    }).toList();
  }

  // ------------------------------------------------------------
  // Add
  // ------------------------------------------------------------

  @override
  Future<void> addItem() async {
    final service = await ServiceDialog.show(context);

    if (service == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'سرویس با موفقیت ثبت شد.');

    await loadData();
  }

  // ------------------------------------------------------------
  // Edit
  // ------------------------------------------------------------

  @override
  Future<void> editItem(int index) async {
    final services = _filteredServices;

    if (index < 0 || index >= services.length) {
      return;
    }

    final service = services[index];

    if (service.id == null) {
      AppNotifier.error(context, 'شناسه سرویس مشخص نیست.');
      return;
    }

    final updatedService = await ServiceDialog.show(context, service: service);

    if (updatedService == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'اطلاعات سرویس با موفقیت ویرایش شد.');

    await loadData();
  }

  // ------------------------------------------------------------
  // Delete
  // ------------------------------------------------------------

  @override
  Future<void> deleteItem(int index) async {
    final services = _filteredServices;

    if (index < 0 || index >= services.length) {
      return;
    }

    final service = services[index];

    if (service.id == null) {
      AppNotifier.error(context, 'شناسه سرویس مشخص نیست.');
      return;
    }

    final confirmed = await AppDeleteDialog.show(
      context,
      title: 'حذف سرویس',
      message: 'آیا از حذف این سرویس مطمئن هستید؟',
    );

    if (!confirmed) {
      return;
    }

    try {
      await _serviceApi.deleteService(service.id!);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'سرویس با موفقیت حذف شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(context, 'حذف سرویس با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Customer
  // ------------------------------------------------------------

  CustomerModel? _getCustomer(int customerId) {
    for (final customer in _customers) {
      if (customer.id == customerId) {
        return customer;
      }
    }

    return null;
  }

  String _getCustomerName(int customerId) {
    return _getCustomer(customerId)?.fullName ?? '---';
  }

  // ------------------------------------------------------------
  // Extinguisher
  // ------------------------------------------------------------

  ExtinguisherModel? _getExtinguisher(int extinguisherId) {
    for (final extinguisher in _extinguishers) {
      if (extinguisher.id == extinguisherId) {
        return extinguisher;
      }
    }

    return null;
  }

  String _getExtinguisherSerial(int extinguisherId) {
    return _getExtinguisher(extinguisherId)?.serialNumber ?? '---';
  }

  // ------------------------------------------------------------
  // Requested Items
  // ------------------------------------------------------------

  String _getRequestedItems(ServiceModel service) {
    final items = <String>[];

    if (service.needsValve) {
      items.add('شیر');
    }

    if (service.needsGauge) {
      items.add('درجه');
    }

    if (service.needsPipe) {
      items.add('میل آب');
    }

    if (service.needsPowder) {
      items.add('پودر');
    }

    if (service.needsHose) {
      items.add('شیلنگ');
    }

    if (items.isEmpty) {
      return '-';
    }

    return items.join('، ');
  }

  // ------------------------------------------------------------
  // Date
  // ------------------------------------------------------------

  String _formatDate(DateTime date) {
    return AppDateUtils.toPersianDate(date);
  }

  // ------------------------------------------------------------
  // Normalize Search
  // ------------------------------------------------------------

  String _normalizeSearchText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ة', 'ه');
  }

  // ------------------------------------------------------------
  // Rows
  // ------------------------------------------------------------

  @override
  List<List<Widget>> get rows {
    return _filteredServices.map((service) {
      return [
        Text(service.id?.toString() ?? '-'),

        Text(_getCustomerName(service.customerId)),

        Text(_getExtinguisherSerial(service.extinguisherId)),

        Text(_formatDate(service.serviceDate)),

        Text(_formatDate(service.nextServiceDate)),

        Text(_getRequestedItems(service)),

        const SizedBox.shrink(),
      ];
    }).toList();
  }
}
