import 'package:flutter/material.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';

import 'package:new_project_fes/features/services/model/service_model.dart';
import 'package:new_project_fes/features/services/pages/wiget/service_form_dialog.dart'
    show ServiceDialog;
import 'package:new_project_fes/features/services/repository/services_api.dart';

class ServicesPage extends AppFormPage {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends AppFormPageState<ServicesPage> {
  final ServiceApi _serviceApi = ServiceApi(ApiClient());

  List<ServiceModel> _services = [];

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
  bool get showEditAction => false;

  @override
  bool get showDeleteAction => false;

  // ------------------------------------------------------------
  // Columns
  // ------------------------------------------------------------

  @override
  List<AppTableColumn> get columns => const [
    AppTableColumn(title: 'شناسه', width: AppTableSizes.code),
    AppTableColumn(title: 'مشتری', width: AppTableSizes.code),
    AppTableColumn(title: 'کپسول', width: AppTableSizes.code),
    AppTableColumn(title: 'تاریخ سرویس', width: AppTableSizes.date),
    AppTableColumn(title: 'سرویس بعدی', width: AppTableSizes.date),
    AppTableColumn(title: 'موارد موردنیاز', width: AppTableSizes.name),
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
      final services = await _serviceApi.getServices();

      if (!mounted) return;

      setState(() {
        _services = services;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppNotifier.error(context, 'دریافت لیست سرویس‌ها با خطا مواجه شد.');
    }
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
    // فعلاً ویرایش سرویس نداریم.
  }

  // ------------------------------------------------------------
  // Delete
  // ------------------------------------------------------------

  @override
  Future<void> deleteItem(int index) async {
    // فعلاً حذف سرویس نداریم.
  }

  // ------------------------------------------------------------
  // Search
  // ------------------------------------------------------------

  @override
  void onSearchChanged(String value) {
    // چون فعلاً showSearchBox = false است،
    // این متد در صفحه استفاده نمی‌شود.
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
    return '${date.year.toString().padLeft(4, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }

  // ------------------------------------------------------------
  // Rows
  // ------------------------------------------------------------

  @override
  List<List<Widget>> get rows {
    return _services.map((service) {
      return [
        Text(service.id?.toString() ?? '-'),
        Text(service.customerId.toString()),
        Text(service.extinguisherId.toString()),
        Text(_formatDate(service.serviceDate)),
        Text(_formatDate(service.nextServiceDate)),
        Text(_getRequestedItems(service)),
      ];
    }).toList();
  }
}
