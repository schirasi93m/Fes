import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/network/api_client.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/features/users/models/app_user_model.dart';
import 'package:new_project_fes/features/users/repository/user_repository_api.dart';
import 'package:new_project_fes/features/users/widgets/user_form_dialog.dart';

class UsersPage extends AppFormPage {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends AppFormPageState<UsersPage> {
  late final UserRepositoryApi _userRepository;

  bool _repositoryInitialized = false;

  List<AppUserModel> _users = [];
  @override
  bool get showEditAction => false;

  @override
  bool get showDeleteAction => false;

  String? _errorMessage;
  bool _errorShown = false;

  @override
  void initState() {
    try {
      debugPrint('[UsersPage.initState] شروع initialization');

      _userRepository = UserRepositoryApi(ApiClient());

      _repositoryInitialized = true;

      debugPrint('[UsersPage.initState] UserRepository initialize شد');
    } catch (e) {
      debugPrint('[UsersPage.initState] خطا در ایجاد UserRepository: $e');

      _repositoryInitialized = false;
      _errorMessage = 'خطا در راه‌اندازی مخزن کاربران: $e';
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_errorMessage != null && !_errorShown) {
      _errorShown = true;

      final errorMsg = _errorMessage;
      _errorMessage = null;

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted && errorMsg != null) {
          AppNotifier.error(context, errorMsg);
        }
      });
    }
  }

  @override
  String get pageTitle => 'کاربران';

  @override
  String get searchHint => 'جست‌وجوی کاربر...';

  @override
  String get primaryButtonText => 'کاربر جدید';

  @override
  bool get showFilter => false;

  List<AppUserModel> get _filteredUsers {
    final query = searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _users;
    }

    return _users.where((user) {
      return user.fullName.toLowerCase().contains(query) ||
          user.username.toLowerCase().contains(query) ||
          user.role.toLowerCase().contains(query);
    }).toList();
  }

  @override
  List<AppTableColumn> get columns => const [
    AppTableColumn(title: 'نام کاربر', width: AppTableSizes.name),
    AppTableColumn(title: 'نام کاربری', width: 190),
    AppTableColumn(title: 'نقش', width: 180),
    AppTableColumn(title: 'وضعیت', width: AppTableSizes.status),
  ];

  @override
  List<List<Widget>> get rows {
    return _filteredUsers.map((user) {
      return [
        Text(user.fullName),

        Text(user.username, textDirection: TextDirection.ltr),

        Text(user.role),

        StatusBadge(
          text: user.isActive ? 'فعال' : 'غیرفعال',
          type: user.isActive
              ? StatusBadgeType.success
              : StatusBadgeType.warning,
        ),
      ];
    }).toList();
  }

  @override
  Future<void> loadData() async {
    _errorShown = false;

    if (!_repositoryInitialized) {
      debugPrint('[UsersPage.loadData] خطا: UserRepository initialize نشده');

      if (mounted) {
        setState(() {
          _errorMessage = _errorMessage ?? 'خطا: مخزن کاربران آماده نیست';

          isLoading = false;
        });
      }

      return;
    }

    try {
      debugPrint('[UsersPage.loadData] شروع درخواست GET /Users');

      final users = await _userRepository.getList();

      debugPrint('[UsersPage.loadData] دریافت ${users.length} کاربر از API');

      if (mounted) {
        setState(() {
          _users = users;
          _errorMessage = null;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint(
        '[UsersPage.loadData] خطا: $e '
        '(نوع: ${e.runtimeType})',
      );

      if (mounted) {
        setState(() {
          _errorMessage = 'خطا در دریافت لیست کاربران: $e';

          isLoading = false;
        });
      }
    }
  }

  @override
  Future<void> addItem() async {
    if (!_repositoryInitialized) {
      debugPrint('[UsersPage.addItem] خطا: UserRepository initialize نشده');

      if (mounted) {
        AppNotifier.error(context, 'خطا: مخزن کاربران آماده نیست');
      }

      return;
    }

    try {
      final user = await UserFormDialog.show(context);

      if (user == null || !mounted) {
        return;
      }

      setState(() {
        _users.add(user);
      });

      AppNotifier.success(context, 'کاربر جدید با موفقیت ثبت شد.');
    } catch (e) {
      debugPrint('[UsersPage.addItem] خطا: $e');

      if (mounted) {
        AppNotifier.error(context, 'خطا در اضافه کردن کاربر: $e');
      }
    }
  }

  // ---------------------------------------------------------------------------
  // ویرایش و حذف در این صفحه غیرفعال هستند.
  // این متدها به دلیل قرارداد AppFormPageState باید وجود داشته باشند.
  // ---------------------------------------------------------------------------

  @override
  Future<void> editItem(int index) async {
    // ویرایش کاربر در این صفحه غیرفعال است.
  }

  @override
  Future<void> deleteItem(int index) async {
    // حذف کاربر در این صفحه غیرفعال است.
  }

  @override
  void onSearchChanged(String value) {
    setState(() {});
  }
}
