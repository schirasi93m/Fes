import 'package:flutter/material.dart';

import '../../models/app_table_column.dart';
import '../../theme/app_colors.dart';
import 'app_table_cell.dart';

class AppTableRow extends StatefulWidget {
  final List<Widget> row;
  final List<AppTableColumn> columns;
  final bool isEven;

  const AppTableRow({
    super.key,
    required this.row,
    required this.columns,
    required this.isEven,
  });

  @override
  State<AppTableRow> createState() => _AppTableRowState();
}

class _AppTableRowState extends State<AppTableRow> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: hovering
              ? AppColors.tableRowSelected
              : widget.isEven
                  ? AppColors.surface
                  : AppColors.tableAlternateRow,
          border: Border(
            top: BorderSide(color: AppColors.border),
          ),
        ),
        child: Row(
          children: List.generate(widget.columns.length, (index) {
            return AppTableCell(
              width: widget.columns[index].width,
              child: widget.row[index],
            );
          }),
        ),
      ),
    );
  }
}