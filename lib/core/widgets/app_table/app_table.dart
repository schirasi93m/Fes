import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';

import 'app_table_cell.dart';
import 'app_table_row.dart';

class AppTable extends StatelessWidget {
  final List<AppTableColumn> columns;
  final List<List<Widget>> rows;

  // Actions
  final bool showEditAction;
  final bool showDeleteAction;

  final ValueChanged<int>? onEdit;
  final ValueChanged<int>? onDelete;

  const AppTable({
    super.key,
    required this.columns,
    required this.rows,

    // Actions
    this.showEditAction = false,
    this.showDeleteAction = false,
    this.onEdit,
    this.onDelete,
  });

  double get _totalWidth {
    return columns.fold<double>(0, (sum, column) => sum + column.width);
  }

  bool get _hasActions {
    return showEditAction || showDeleteAction;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: _totalWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.tableAlternateRow,
      child: Row(
        children: columns.map((column) {
          return AppTableCell(
            width: column.width,
            child: Text(column.title, style: AppTextStyles.titleMedium),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final row = rows[index];

        if (!_hasActions) {
          return AppTableRow(row: row, columns: columns, isEven: index.isEven);
        }

        return _buildRowWithActions(context, row, index);
      },
    );
  }

  Widget _buildRowWithActions(
    BuildContext context,
    List<Widget> row,
    int rowIndex,
  ) {
    final int actionColumnIndex = columns.length - 1;

    final List<Widget> cells = [];

    for (int i = 0; i < actionColumnIndex; i++) {
      if (i < row.length) {
        cells.add(row[i]);
      } else {
        cells.add(const SizedBox.shrink());
      }
    }

    cells.add(_buildActions(context, rowIndex));

    return AppTableRow(row: cells, columns: columns, isEven: rowIndex.isEven);
  }

  Widget _buildActions(BuildContext context, int rowIndex) {
    return Row(
      children: [
        if (showEditAction)
          AppButton(
            type: AppButtonType.icon,
            icon: AppIcons.edit,
            tooltip: 'ویرایش کاربر',
            onPressed: () {
              onEdit?.call(rowIndex);
            },
          ),
        if (showDeleteAction)
          AppButton(
            type: AppButtonType.icon,
            icon: AppIcons.delete,
            tooltip: 'حدف کاربر',
            onPressed: () {
              onDelete?.call(rowIndex);
            },
          ),
      ],
    );
  }
}
