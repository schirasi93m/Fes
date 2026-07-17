import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';

import 'app_table_cell.dart';
import 'app_table_row.dart';

class AppTable extends StatelessWidget {
  final List<AppTableColumn> columns;
  final List<List<Widget>> rows;

  const AppTable({super.key, required this.columns, required this.rows});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildHeader(), _buildBody()],
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
    return Column(
      children: List.generate(rows.length, (index) {
        return AppTableRow(
          row: rows[index],
          columns: columns,
          isEven: index.isEven,
        );
      }),
    );
  }
}
