import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_date_utils.dart';
import 'package:new_project_fes/core/widgets/app_delete_dialog.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/features/code_title/controllers/code_title_controller.dart';
import 'package:new_project_fes/features/code_title/models/code_title_model.dart';
import 'package:new_project_fes/features/code_title/repository/code_title_repository_api.dart';
import 'package:new_project_fes/features/customers/controllers/customer_controller.dart';
import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/repository/customer_repository_api.dart';
import 'package:new_project_fes/features/extinguishers/controllers/extinguisher_controller.dart';
import 'package:new_project_fes/features/extinguishers/repository/extinguisher_repository_api.dart';
import '../models/extinguishers_model.dart';
import '../widget/extinguisher_form_dialog.dart';

class ExtinguisherPage extends AppFormPage {
  final VoidCallback? onCustomersPressed;
  final ValueChanged<CustomerModel>? onCustomerEdit;

  const ExtinguisherPage({
    super.key,
    this.onCustomersPressed,
    this.onCustomerEdit,
  });

  @override
  State<ExtinguisherPage> createState() => _ExtinguisherPageState();
}

class _ExtinguisherPageState extends AppFormPageState<ExtinguisherPage> {
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

  // ------------------------------------------------------------
  // Page Settings
  // ------------------------------------------------------------

  @override
  String get pageTitle => 'کپسول‌ها';

  @override
  bool get showFilter => false;

  @override
  String get searchHint => 'جستجوی کپسول...';

  @override
  String get primaryButtonText => 'کپسول جدید';

  // ------------------------------------------------------------
  // Table
  // ------------------------------------------------------------

  @override
  List<AppTableColumn> get columns => const [
    AppTableColumn(title: 'کد', width: AppTableSizes.number),
    AppTableColumn(title: 'مشتری', width: AppTableSizes.name),
    AppTableColumn(title: 'نوع', width: AppTableSizes.number),
    AppTableColumn(title: 'ظرفیت', width: AppTableSizes.number),
    AppTableColumn(title: 'آخرین سرویس', width: AppTableSizes.date),
    AppTableColumn(title: 'سرویس بعدی', width: AppTableSizes.date),
    AppTableColumn(title: 'محل استقرار', width: AppTableSizes.address),
    AppTableColumn(title: 'وضعیت', width: AppTableSizes.status),
    AppTableColumn(title: 'عملیات', width: AppTableSizes.actions),
  ];

  // ------------------------------------------------------------
  // Search
  // ------------------------------------------------------------

  @override
  void onSearchChanged(String value) {
    setState(() {});
  }

  List<ExtinguisherModel> get _filteredExtinguishers {
    final query = _normalizeSearchText(searchController.text);

    if (query.isEmpty) {
      return _extinguishers;
    }

    return _extinguishers.where((extinguisher) {
      final customer = _getCustomer(extinguisher.customerId);
      final codeTitle = _getCodeTitle(extinguisher.typeId);

      return _normalizeSearchText(extinguisher.serialNumber).contains(query) ||
          _normalizeSearchText(extinguisher.location ?? '').contains(query) ||
          extinguisher.typeId.toString().contains(query) ||
          extinguisher.customerId.toString().contains(query) ||
          (customer != null &&
              (_normalizeSearchText(customer.fullName).contains(query) ||
                  customer.code.toString().contains(query) ||
                  _normalizeSearchText(customer.phone).contains(query) ||
                  _normalizeSearchText(customer.address).contains(query))) ||
          (codeTitle != null &&
              (_normalizeSearchText(codeTitle.title).contains(query) ||
                  _normalizeSearchText(codeTitle.latinTitle).contains(query) ||
                  codeTitle.id.toString().contains(query) ||
                  codeTitle.code.toString().contains(query)));
    }).toList();
  }

  // ------------------------------------------------------------
  // Load
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
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      AppNotifier.error(context, 'دریافت اطلاعات کپسول‌ها با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Add
  // ------------------------------------------------------------

  @override
  Future<void> addItem() async {
    final extinguisher = await ExtinguisherDialog.show(
      context,
      controller: _controller,
      onCustomersPressed: widget.onCustomersPressed,
      onCustomerEdit: widget.onCustomerEdit,
    );

    if (extinguisher == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'کپسول با موفقیت ثبت شد.');

    await loadData();
  }

  // ------------------------------------------------------------
  // Edit
  // ------------------------------------------------------------

  @override
  Future<void> editItem(int index) async {
    final extinguisher = _filteredExtinguishers[index];

    final updatedExtinguisher = await ExtinguisherDialog.show(
      context,
      controller: _controller,
      extinguisher: extinguisher,
      onCustomersPressed: widget.onCustomersPressed,
      onCustomerEdit: widget.onCustomerEdit,
    );

    if (updatedExtinguisher == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    AppNotifier.success(context, 'اطلاعات کپسول با موفقیت ویرایش شد.');

    await loadData();
  }

  // ------------------------------------------------------------
  // Delete
  // ------------------------------------------------------------

  @override
  Future<void> deleteItem(int index) async {
    final confirmed = await AppDeleteDialog.show(
      context,
      title: 'حذف کپسول',
      message: 'آیا از حذف این کپسول مطمئن هستید؟',
    );

    if (!confirmed) {
      return;
    }

    final extinguisher = _filteredExtinguishers[index];

    try {
      await _controller.remove(extinguisher);

      if (!mounted) {
        return;
      }

      AppNotifier.success(context, 'کپسول با موفقیت حذف شد.');

      await loadData();
    } catch (e) {
      if (!mounted) {
        return;
      }

      AppNotifier.error(context, 'حذف کپسول با خطا مواجه شد.');
    }
  }

  // ------------------------------------------------------------
  // Rows
  // ------------------------------------------------------------

  @override
  List<List<Widget>> get rows {
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
          text: extinguisher.isActive ? 'فعال' : 'غیرفعال',
          type: extinguisher.isActive
              ? StatusBadgeType.success
              : StatusBadgeType.warning,
        ),

        const SizedBox.shrink(),
      ];
    }).toList();
  }

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------

  CustomerModel? _getCustomer(int customerId) {
    for (final customer in _customers) {
      if (customer.id == customerId) {
        return customer;
      }
    }

    return null;
  }

  CodeTitleModel? _getCodeTitle(int typeId) {
    for (final codeTitle in _codeTitleList) {
      if (codeTitle.id == typeId || codeTitle.code == typeId) {
        return codeTitle;
      }
    }

    return null;
  }

  String _getCustomerName(int customerId) {
    return _getCustomer(customerId)?.fullName ?? '---';
  }

  String _getTitleByTypeId(int typeId) {
    return _getCodeTitle(typeId)?.title ?? '---';
  }

  String _normalizeSearchText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('ي', 'ی')
        .replaceAll('ك', 'ک')
        .replaceAll('ة', 'ه');
  }

  String _formatDate(DateTime date) {
    return AppDateUtils.toPersianDate(date);
  }
}
