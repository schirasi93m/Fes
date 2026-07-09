import 'package:flutter/material.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_colors.dart';
import 'package:new_project_fes/core/theme/app_radius.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/theme/app_text_style.dart';

class AppTable extends StatelessWidget {
  final List<AppTableColumn> columns;
  final List<List<Widget>> rows;

  const AppTable({
    super.key,
    required this.columns,
    required this.rows,
  });

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
            children: [
              _buildHeader(),
              _buildBody(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: AppColors.background,
      child: Row(
        children: columns.map((column) {
          return SizedBox(
            width: column.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.lg,
              ),
              child: Text(
                column.title,
                style: AppTextStyles.titleMedium,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: List.generate(rows.length, (rowIndex) {
        final row = rows[rowIndex];

        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppColors.border,
              ),
            ),
          ),
          child: Row(
            children: List.generate(columns.length, (columnIndex) {
              return SizedBox(
                width: columns[columnIndex].width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.lg,
                  ),
                  child: row[columnIndex],
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}