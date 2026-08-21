import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/app_page_toolbar.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/features/code_title/controllers/code_title_controller.dart';
import 'package:new_project_fes/features/code_title/models/code_title_model.dart';
import 'package:new_project_fes/features/code_title/repository/code_title_repository_api.dart';

import 'package:new_project_fes/features/customers/controllers/customer_controller.dart';
import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/repository/customer_repository_api.dart';

import 'package:new_project_fes/features/extinguishers/controllers/extinguisher_controller.dart';
import 'package:new_project_fes/features/extinguishers/repository/extinguisher_repository_api.dart';
import 'package:new_project_fes/features/extinguishers/widget/extinguisher_delete_dialog.dart';

import '../models/extinguishers_model.dart';
import '../widget/extinguisher_form_dialog.dart';

class ExtinguisherPage extends StatefulWidget {
  const ExtinguisherPage({super.key});

  @override
  State<ExtinguisherPage> createState() => _ExtinguisherPageState();
}

class _ExtinguisherPageState extends State<ExtinguisherPage> {
  final TextEditingController searchController = TextEditingController();

  final ExtinguisherController _controller = ExtinguisherController(
    ExtinguisherRepositoryApi(ApiClient()),
  );

  final CustomerController _customerController = CustomerController(
    CustomerRepositoryApi(ApiClient()),
  );
  final CodeTitleController _codeTitle = CodeTitleController(
    CodeTitleRepositoryApi(ApiClient()),
  );
  List<ExtinguisherModel> _extinguishers = [];
  List<CustomerModel> _customers = [];
  List<CodeTitleModel> _codeTitleList = [];
  bool _isLoading = true;

  List<ExtinguisherModel> get _filteredExtinguishers {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _extinguishers;
    }

    return _extinguishers.where((extinguisher) {
      final customerName = _getCustomerName(
        extinguisher.customerId,
      ).toLowerCase();
      final typeTitle = _getTitleByTypeId(extinguisher.typeId).toLowerCase();
      return extinguisher.serialNumber.toLowerCase().contains(query) ||
          (extinguisher.location?.toLowerCase().contains(query) ?? false) ||
          extinguisher.typeId.toString().contains(query) ||
          extinguisher.customerId.toString().contains(query) ||
          customerName.contains(query) ||
          typeTitle.contains(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadExtinguishers();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadExtinguishers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final results = await Future.wait([
        _controller.getAll(),
        _customerController.getAll(),
        _codeTitle.getByCategoryId(2),
      ]);

      final extinguishers = results[0] as List<ExtinguisherModel>;

      final customers = results[1] as List<CustomerModel>;

      final codeTitles = results[2] as List<CodeTitleModel>;

      if (!mounted) {
        return;
      }

      setState(() {
        _extinguishers = extinguishers;
        _customers = customers;
        _codeTitleList = codeTitles;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });

      AppNotifier.error(context, 'دریافت اطلاعات کپسول‌ها با خطا مواجه شد.');
    }
  }

  String _getCustomerName(int customerId) {
    for (final customer in _customers) {
      if (customer.id == customerId) {
        return customer.fullName;
      }
    }

    return '---';
  }

  String _getTitleByTypeId(int typeId) {
    for (final codeTitle in _codeTitleList) {
      if (codeTitle.id == typeId) {
        return codeTitle.title;
      }
    }
    return '---';
  }

  Future<void> _addExtinguisher() async {
    final extinguisher = await ExtinguisherDialog.show(
      context,
      controller: _controller,
    );

    if (extinguisher == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'کپسول با موفقیت ثبت شد.');

    await _loadExtinguishers();
  }

  Future<void> _editExtinguisher(int index) async {
    final extinguishers = _filteredExtinguishers;
    final extinguisher = extinguishers[index];

    final updatedExtinguisher = await ExtinguisherDialog.show(
      context,
      controller: _controller,
      extinguisher: extinguisher,
    );

    if (updatedExtinguisher == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'اطلاعات کپسول با موفقیت ویرایش شد.');

    await _loadExtinguishers();
  }

  Future<void> _deleteExtinguisher(int index) async {
    final confirmed = await ExtinguisherDeleteDialog.show(context);

    if (!confirmed) {
      return;
    }

    final extinguishers = _filteredExtinguishers;
    final extinguisher = extinguishers[index];

    try {
      await _controller.remove(extinguisher);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'کپسول با موفقیت حذف شد.');

      await _loadExtinguishers();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(context, 'حذف کپسول با خطا مواجه شد.');
    }
  }

  void _applySearch(String value) {
    setState(() {});
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }

  List<List<Widget>> _buildRows() {
    return _filteredExtinguishers.map((extinguisher) {
      return [
        Text(extinguisher.serialNumber),
        Text(_getCustomerName(extinguisher.customerId)),
        Text(_getTitleByTypeId(extinguisher.typeId)),
        Text(extinguisher.capacity.toString()),
        Text(_formatDate(extinguisher.lastServiceDate ?? DateTime.now())),
        Text(_formatDate(extinguisher.nextServiceDate ?? DateTime.now())),
        Text(extinguisher.location ?? ''),
        StatusBadge(
          text: extinguisher.isActive ? "فعال" : "غیرفعال",
          type: extinguisher.isActive
              ? StatusBadgeType.success
              : StatusBadgeType.warning,
        ),
        const SizedBox.shrink(),
      ];
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          PageToolbar(
            searchController: searchController,
            searchHint: 'جستجوی کپسول...',
            showRefresh: true,
            showFilter: true,
            primaryButtonText: 'کپسول جدید',
            onPrimaryPressed: _addExtinguisher,
            onRefreshPressed: _loadExtinguishers,
            onSearchChanged: _applySearch,
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : AppTable(
                    showDeleteAction: true,
                    showEditAction: true,
                    onEdit: _editExtinguisher,
                    onDelete: _deleteExtinguisher,
                    columns: const [
                      AppTableColumn(title: 'کد', width: AppTableSizes.number),
                      AppTableColumn(title: 'مشتری', width: AppTableSizes.name),
                      AppTableColumn(title: 'نوع', width: AppTableSizes.number),
                      AppTableColumn(
                        title: 'ظرفیت',
                        width: AppTableSizes.number,
                      ),
                      AppTableColumn(
                        title: 'آخرین سرویس',
                        width: AppTableSizes.date,
                      ),
                      AppTableColumn(
                        title: 'سرویس بعدی',
                        width: AppTableSizes.date,
                      ),
                      AppTableColumn(
                        title: 'محل استقرار',
                        width: AppTableSizes.address,
                      ),
                      AppTableColumn(
                        title: 'وضعیت',
                        width: AppTableSizes.status,
                      ),
                      AppTableColumn(
                        title: 'عملیات',
                        width: AppTableSizes.actions,
                      ),
                    ],
                    rows: _buildRows(),
                  ),
          ),
        ],
      ),
    );
  }
}
