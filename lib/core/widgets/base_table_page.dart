import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'app_page_toolbar.dart';

abstract class BaseTablePage extends StatefulWidget {
  final String searchHint;
  final String primaryButtonText;

  const BaseTablePage({
    super.key,
    required this.searchHint,
    required this.primaryButtonText,
  });
}

abstract class BaseTablePageState<T extends BaseTablePage> extends State<T> {
  late final TextEditingController searchController;

  bool get isLoading;
  Future<void> loadData();
  void onSearchChanged(String value) {}
  void onFilterPressed() {}
  Future<void> onPrimaryPressed();
  Widget buildTable(BuildContext context);

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          PageToolbar(
            searchController: searchController,
            searchHint: widget.searchHint,
            onSearchChanged: onSearchChanged,
            showFilter: true,
            showRefresh: true,
            onFilterPressed: onFilterPressed,
            onRefreshPressed: loadData,
            primaryButtonText: widget.primaryButtonText,
            onPrimaryPressed: onPrimaryPressed,
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildTable(context),
          ),
        ],
      ),
    );
  }
}
