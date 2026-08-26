import 'package:flutter/material.dart';

import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';

import 'package:new_project_fes/features/code_title/models/code_title_model.dart';
import 'package:new_project_fes/features/code_title/repository/code_title_repository_api.dart';

import 'package:new_project_fes/features/customers/models/customer_model.dart';
import 'package:new_project_fes/features/customers/repository/customer_repository_api.dart';

import 'package:new_project_fes/features/extinguishers/models/extinguishers_model.dart';
import 'package:new_project_fes/features/extinguishers/repository/extinguisher_repository_api.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // ---------------------------------------------------------------------------
  // Repositories
  // ---------------------------------------------------------------------------

  final CustomerRepositoryApi _customerRepository = CustomerRepositoryApi(
    ApiClient(),
  );

  final ExtinguisherRepositoryApi _extinguisherRepository =
      ExtinguisherRepositoryApi(ApiClient());

  final CodeTitleRepositoryApi _codeTitleRepository = CodeTitleRepositoryApi(
    ApiClient(),
  );

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  List<CustomerModel> _customers = [];
  List<ExtinguisherModel> _extinguishers = [];
  List<CodeTitleModel> _extinguisherTypes = [];

  bool _isLoading = true;
  String? _errorMessage;

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ---------------------------------------------------------------------------
  // Data
  // ---------------------------------------------------------------------------

  Future<void> _loadData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

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
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'اتصال به API برقرار نشد.\nمطمئن شوید سرور در حال اجراست.';
      });
    }
  }

  // ---------------------------------------------------------------------------
  // Calculations
  // ---------------------------------------------------------------------------

  List<ExtinguisherModel> get _dueExtinguishers {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _extinguishers.where((extinguisher) {
      final nextServiceDate = extinguisher.nextServiceDate;

      if (nextServiceDate == null) {
        return false;
      }

      final serviceDate = DateTime(
        nextServiceDate.year,
        nextServiceDate.month,
        nextServiceDate.day,
      );

      return serviceDate.isBefore(today) || serviceDate.isAtSameMomentAs(today);
    }).toList()..sort((a, b) {
      final dateA = a.nextServiceDate;
      final dateB = b.nextServiceDate;

      if (dateA == null && dateB == null) {
        return 0;
      }

      if (dateA == null) {
        return 1;
      }

      if (dateB == null) {
        return -1;
      }

      return dateA.compareTo(dateB);
    });
  }

  CustomerModel? _getCustomer(int customerId) {
    for (final customer in _customers) {
      if (customer.id == customerId) {
        return customer;
      }
    }

    return null;
  }

  CodeTitleModel? _getExtinguisherType(int typeId) {
    for (final type in _extinguisherTypes) {
      if (type.id == typeId || type.code == typeId) {
        return type;
      }
    }

    return null;
  }

  String _getCustomerName(int customerId) {
    return _getCustomer(customerId)?.fullName ?? '---';
  }

  String _getExtinguisherTypeName(int typeId) {
    return _getExtinguisherType(typeId)?.title ?? '---';
  }

  String _formatDate(DateTime? date) {
    if (date == null) {
      return '---';
    }

    return '${date.year.toString().padLeft(4, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime? date) {
    if (date == null) {
      return false;
    }

    final now = DateTime.now();

    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // ---------------------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    final dueExtinguishers = _dueExtinguishers;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isSmall ? AppSpacing.md : AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPageHeader(),
              SizedBox(height: isSmall ? AppSpacing.md : AppSpacing.lg),
              _buildSummaryCards(dueExtinguishers),
              SizedBox(height: isSmall ? AppSpacing.lg : AppSpacing.xl),
              _buildDueSection(dueExtinguishers),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Page Header
  // ---------------------------------------------------------------------------

  Widget _buildPageHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'داشبورد',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'نمای کلی وضعیت مشتریان و کپسول‌های آتش‌نشانی',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _buildRefreshButton(),
      ],
    );
  }

  Widget _buildRefreshButton() {
    return Tooltip(
      message: 'به‌روزرسانی اطلاعات',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: _isLoading ? null : _loadData,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.refresh_rounded, size: 21),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Summary Cards
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCards(List<ExtinguisherModel> dueExtinguishers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width < 650) {
          return Column(
            children: [
              _buildSummaryCard(
                title: 'مشتریان',
                value: _customers.length.toString(),
                subtitle: 'مشتری ثبت شده',
                icon: AppIcons.customer,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSummaryCard(
                title: 'کپسول‌ها',
                value: _extinguishers.length.toString(),
                subtitle: 'کپسول ثبت شده',
                icon: AppIcons.extinguisher,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildSummaryCard(
                title: 'نیاز به سرویس',
                value: dueExtinguishers.length.toString(),
                subtitle: 'مورد نیازمند پیگیری',
                icon: AppIcons.warning,
                isWarning: dueExtinguishers.isNotEmpty,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                title: 'مشتریان',
                value: _customers.length.toString(),
                subtitle: 'مشتری ثبت شده',
                icon: AppIcons.customer,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                title: 'کپسول‌ها',
                value: _extinguishers.length.toString(),
                subtitle: 'کپسول ثبت شده',
                icon: AppIcons.extinguisher,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildSummaryCard(
                title: 'نیاز به سرویس',
                value: dueExtinguishers.length.toString(),
                subtitle: 'مورد نیازمند پیگیری',
                icon: AppIcons.warning,
                isWarning: dueExtinguishers.isNotEmpty,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    bool isWarning = false,
  }) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.card),
      child: Container(
        constraints: const BoxConstraints(minHeight: 128),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          border: Border.all(
            color: isWarning && _dueExtinguishers.isNotEmpty
                ? Colors.orange.withValues(alpha: 0.25)
                : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.035),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildSummaryIcon(icon: icon, isWarning: isWarning),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryIcon({required IconData icon, required bool isWarning}) {
    final iconColor = isWarning ? Colors.orange : AppColors.primary;

    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Icon(icon, color: iconColor, size: 25),
    );
  }

  // ---------------------------------------------------------------------------
  // Due Section
  // ---------------------------------------------------------------------------

  Widget _buildDueSection(List<ExtinguisherModel> dueExtinguishers) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSectionHeader(dueExtinguishers),
          const Divider(height: 1),
          if (dueExtinguishers.isEmpty)
            _buildEmptyState()
          else
            _buildDueTable(dueExtinguishers),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(List<ExtinguisherModel> dueExtinguishers) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.card),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'کپسول‌های سررسید شده',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildCountBadge(dueExtinguishers.length),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'کپسول‌هایی که موعد سرویس آن‌ها رسیده یا گذشته است',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        count.toString(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Colors.orange.shade800,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Table
  // ---------------------------------------------------------------------------

  Widget _buildDueTable(List<ExtinguisherModel> extinguishers) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const minimumTableWidth = 760.0;

        final tableWidth = constraints.maxWidth < minimumTableWidth
            ? minimumTableWidth
            : constraints.maxWidth;

        return ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(AppRadius.card),
            bottomRight: Radius.circular(AppRadius.card),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: Column(
                children: [
                  _buildTableHeader(),
                  const Divider(height: 1),
                  ...extinguishers.map(
                    (extinguisher) => _buildTableRow(extinguisher),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      color: AppColors.background,
      child: Row(
        children: [
          _tableHeaderCell(
            title: 'وضعیت',
            flex: 2,
            alignment: Alignment.centerRight,
          ),
          _tableHeaderCell(
            title: 'سرویس بعدی',
            flex: 2,
            alignment: Alignment.centerRight,
          ),
          _tableHeaderCell(
            title: 'مشتری',
            flex: 3,
            alignment: Alignment.centerRight,
          ),
          _tableHeaderCell(
            title: 'نوع',
            flex: 2,
            alignment: Alignment.centerRight,
          ),
          _tableHeaderCell(
            title: 'سریال',
            flex: 2,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }

  Widget _tableHeaderCell({
    required String title,
    required int flex,
    required Alignment alignment,
  }) {
    return Expanded(
      flex: flex,
      child: Align(
        alignment: alignment,
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTableRow(ExtinguisherModel extinguisher) {
    final isToday = _isToday(extinguisher.nextServiceDate);

    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.65)),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: StatusBadge(
                text: isToday ? 'امروز' : 'سررسید شده',
                type: isToday ? StatusBadgeType.warning : StatusBadgeType.error,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: _buildTableText(_formatDate(extinguisher.nextServiceDate)),
          ),
          Expanded(
            flex: 3,
            child: _buildTableText(_getCustomerName(extinguisher.customerId)),
          ),
          Expanded(
            flex: 2,
            child: _buildTableText(
              _getExtinguisherTypeName(extinguisher.typeId),
            ),
          ),
          Expanded(flex: 2, child: _buildSerialText(extinguisher.serialNumber)),
        ],
      ),
    );
  }

  Widget _buildTableText(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.right,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _buildSerialText(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty State
  // ---------------------------------------------------------------------------

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.lg,
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'همه‌چیز مرتب است',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'در حال حاضر هیچ کپسول سررسید شده‌ای وجود ندارد.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Loading
  // ---------------------------------------------------------------------------

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'در حال دریافت اطلاعات...',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Error
  // ---------------------------------------------------------------------------

  Widget _buildErrorState() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 440),
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_off_rounded,
                    size: 30,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'خطا در دریافت اطلاعات',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _errorMessage ?? 'خطایی رخ داده است.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                ElevatedButton.icon(
                  onPressed: _loadData,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تلاش مجدد'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
