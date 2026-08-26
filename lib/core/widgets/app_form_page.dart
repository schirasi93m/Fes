import 'package:flutter/material.dart';

import '../models/app_table_column.dart';
import '../theme/app_colors.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import 'app_page_toolbar.dart';
import 'app_table/app_table.dart';

abstract class AppFormPage extends StatefulWidget {
  const AppFormPage({super.key});
}

abstract class AppFormPageState<T extends AppFormPage> extends State<T> {
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;

  String get pageTitle;

  String get searchHint;

  String get primaryButtonText;

  bool get showSearchBox => true;

  bool get showFilter => true;

  bool get showRefresh => true;

  bool get showEditAction => true;

  bool get showDeleteAction => true;

  List<AppTableColumn> get columns;

  List<List<Widget>> get rows;

  Future<void> loadData();

  Future<void> addItem();

  Future<void> editItem(int index);

  Future<void> deleteItem(int index);

  void onSearchChanged(String value);

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNarrow =
        MediaQuery.sizeOf(context).width < AppSizes.formStackBreakpoint;

    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          PageToolbar(
            searchController: searchController,
            searchHint: searchHint,
            showSreachBox: showSearchBox,
            showRefresh: showRefresh,
            showFilter: showFilter,
            primaryButtonText: primaryButtonText,
            onPrimaryPressed: addItem,
            onRefreshPressed: loadData,
            onSearchChanged: onSearchChanged,
          ),

          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isNarrow ? AppSpacing.none : AppSpacing.sm),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AppTable(
                      showEditAction: showEditAction,
                      showDeleteAction: showDeleteAction,
                      onEdit: editItem,
                      onDelete: deleteItem,
                      columns: columns,
                      rows: rows,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
