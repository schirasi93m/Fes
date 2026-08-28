import 'package:flutter/material.dart';

import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_sizes.dart';
import 'package:new_project_fes/core/widgets/app_delete_dialog.dart';
import 'package:new_project_fes/core/widgets/app_form_page.dart';
import 'package:new_project_fes/core/widgets/app_notifier.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/features/users/models/app_user_model.dart';
import 'package:new_project_fes/features/users/widgets/user_form_dialog.dart';

class UsersPage extends AppFormPage {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends AppFormPageState<UsersPage> {
  final List<AppUserModel> _users = [
    const AppUserModel(
      id: 1,
      fullName: 'مصطفی شیرازی',
      username: 'mostafa.shirazi',
      role: 'مدیر سیستم',
      isActive: true,
    ),
    const AppUserModel(
      id: 2,
      fullName: 'سارا احمدی',
      username: 'sara.ahmadi',
      role: 'کارشناس خدمات',
      isActive: true,
    ),
  ];

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
    if (query.isEmpty) return _users;
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
    AppTableColumn(title: 'عملیات', width: AppTableSizes.actions),
  ];

  @override
  List<List<Widget>> get rows => _filteredUsers.map((user) {
    return [
      Text(user.fullName),
      Text(user.username, textDirection: TextDirection.ltr),
      Text(user.role),
      StatusBadge(
        text: user.isActive ? 'فعال' : 'غیرفعال',
        type: user.isActive ? StatusBadgeType.success : StatusBadgeType.warning,
      ),
      const SizedBox.shrink(),
    ];
  }).toList();

  @override
  Future<void> loadData() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Future<void> addItem() async {
    final user = await UserFormDialog.show(context);
    if (user == null || !mounted) return;
    setState(() => _users.add(user));
    AppNotifier.success(context, 'کاربر جدید با موفقیت ثبت شد.');
  }

  @override
  Future<void> editItem(int index) async {
    final selectedUser = _filteredUsers[index];
    final user = await UserFormDialog.show(context, user: selectedUser);
    if (user == null || !mounted) return;
    final userIndex = _users.indexWhere((item) => item.id == selectedUser.id);
    setState(() => _users[userIndex] = user);
    AppNotifier.success(context, 'اطلاعات کاربر با موفقیت ویرایش شد.');
  }

  @override
  Future<void> deleteItem(int index) async {
    final user = _filteredUsers[index];
    final confirmed = await AppDeleteDialog.show(
      context,
      title: 'حذف کاربر',
      message: 'آیا از حذف «${user.fullName}» مطمئن هستید؟',
    );
    if (!confirmed || !mounted) return;
    setState(() => _users.removeWhere((item) => item.id == user.id));
    AppNotifier.success(context, 'کاربر با موفقیت حذف شد.');
  }

  @override
  void onSearchChanged(String value) => setState(() {});
}
