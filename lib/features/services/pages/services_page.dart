import 'package:flutter/material.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as shamsi;

import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/base_table_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';

import 'package:new_project_fes/features/services/model/service_model.dart';
import 'package:new_project_fes/features/services/repository/services_api.dart';
import 'package:new_project_fes/features/services/widgets/service_form_dialog.dart';

class ServicesPage extends BaseTablePage {
  const ServicesPage({super.key})
      : super(searchHint: 'جستجوی سرویس...', primaryButtonText: 'سرویس جدید');

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends BaseTablePageState<ServicesPage> {
  final ServiceApi _serviceApi = ServiceApi(ApiClient());

  List<ServiceModel> _services = [];
  List<ServiceModel> _filteredServices = [];

  bool _isLoading = true;

  @override
  bool get isLoading => _isLoading;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Future<void> loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _serviceApi.getServices();

      if (!mounted) {
        return;
      }

      setState(() {
        _services = services;
        _filteredServices = services;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      AppNotifier.error(context, 'دریافت لیست سرویس‌ها با خطا مواجه شد.');
    }
  }

  @override
  void onSearchChanged(String value) {
    final query = value.trim();

    setState(() {
      _filteredServices = query.isEmpty
          ? _services
          : _services.where((service) {
              return service.id.toString().contains(query) ||
                  service.customerId.toString().contains(query) ||
                  service.extinguisherId.toString().contains(query);
            }).toList();
    });
  }

  @override
  Future<void> onPrimaryPressed() async {
    final service = await ServiceDialog.show(context);

    if (service == null || !mounted) {
      return;
    }

    setState(() {
      _services = [..._services, service];
      _filteredServices = [..._filteredServices, service];
    });

    AppNotifier.success(context, 'سرویس با موفقیت ثبت شد.');
  }

  Future<void> _editService(int index) async {
    final service = _filteredServices[index];
    final updatedService = await ServiceDialog.show(
      context,
      service: service,
    );

    if (updatedService == null || !mounted) {
      return;
    }

    setState(() {
      _services = _services
          .map((item) => item.id == updatedService.id ? updatedService : item)
          .toList();
      _filteredServices = _filteredServices
          .map((item) => item.id == updatedService.id ? updatedService : item)
          .toList();
    });
    AppNotifier.success(context, 'سرویس با موفقیت ویرایش شد.');
  }

  Future<void> _deleteService(int index) async {
    final service = _filteredServices[index];
    final serviceId = service.id;

    if (serviceId == null) {
      AppNotifier.error(context, 'شناسه سرویس برای حذف موجود نیست.');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('حذف سرویس'),
          content: const Text('آیا از حذف این سرویس مطمئن هستید؟'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('انصراف'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _serviceApi.deleteService(serviceId);
      if (!mounted) {
        return;
      }

      setState(() {
        _services.removeWhere((item) => item.id == serviceId);
        _filteredServices.removeWhere((item) => item.id == serviceId);
      });
      AppNotifier.success(context, 'سرویس با موفقیت حذف شد.');
    } catch (error) {
      if (!mounted) {
        return;
      }
      AppNotifier.error(context, 'حذف سرویس با خطا مواجه شد.');
    }
  }

  @override
  Widget buildTable(BuildContext context) {
    final rows = _filteredServices.map((service) {
      final requestedItems = [
        if (service.needsValve) 'شیر',
        if (service.needsGauge) 'درجه',
        if (service.needsPipe) 'میل آب',
        if (service.needsPowder) 'پودر',
        if (service.needsHose) 'شیلنگ',
      ];

      return [
        Text(service.id?.toString() ?? '-'),

        Text(service.customerId.toString()),

        Text(service.extinguisherId.toString()),

        Text(shamsi.Jalali.fromDateTime(service.serviceDate).formatCompactDate()),

        Text(shamsi.Jalali.fromDateTime(service.nextServiceDate).formatCompactDate()),

        Text(requestedItems.isEmpty ? '-' : requestedItems.join('، ')),
      ];
    }).toList();

    return AppTable(
                    showEditAction: true,
                    showDeleteAction: true,
                    onEdit: _editService,
                    onDelete: _deleteService,
                    columns: const [
                      AppTableColumn(title: 'شناسه', width: AppTableSizes.code),
                      AppTableColumn(title: 'مشتری', width: AppTableSizes.code),
                      AppTableColumn(title: 'کپسول', width: AppTableSizes.code),
                      AppTableColumn(
                        title: 'تاریخ سرویس',
                        width: AppTableSizes.date,
                      ),
                      AppTableColumn(
                        title: 'سرویس بعدی',
                        width: AppTableSizes.date,
                      ),
                      AppTableColumn(
                        title: 'موارد موردنیاز',
                        width: AppTableSizes.name,
                      ),
                      AppTableColumn(
                        title: 'عملیات',
                        width: AppTableSizes.actions,
                      ),
                    ],
                    rows: rows,
    );
  }
}
