import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';
import 'app_search_box.dart';

class PageToolbar extends StatelessWidget {
  // Search
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String searchHint;

  // Buttons
  final bool showFilter;
  final bool showRefresh;
  final bool showExcel;
  final bool showPdf;
  final bool showPrint;

  final VoidCallback? onFilterPressed;
  final VoidCallback? onRefreshPressed;
  final VoidCallback? onExcelPressed;
  final VoidCallback? onPdfPressed;
  final VoidCallback? onPrintPressed;

  // Primary Button
  final String? primaryButtonText;
  final IconData? primaryButtonIcon;
  final VoidCallback? onPrimaryPressed;

  const PageToolbar({
    super.key,

    // Search
    this.searchController,
    this.onSearchChanged,
    this.searchHint = "جستجو...",

    // Buttons
    this.showFilter = false,
    this.showRefresh = false,
    this.showExcel = false,
    this.showPdf = false,
    this.showPrint = false,

    this.onFilterPressed,
    this.onRefreshPressed,
    this.onExcelPressed,
    this.onPdfPressed,
    this.onPrintPressed,

    // Primary Button
    this.primaryButtonText,
    this.primaryButtonIcon,
    this.onPrimaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          //==========================
          // Search
          //==========================
          if (searchController != null)
            SizedBox(
              width: 320,
              child: AppSearchBox(
                controller: searchController!,
                hintText: searchHint,
                onChanged: onSearchChanged,
              ),
            ),

          if (searchController != null) const SizedBox(width: AppSpacing.md),

          //==========================
          // Action Buttons
          //==========================
          if (showRefresh)
            AppButton(
              icon: AppIcons.refresh,
              type: AppButtonType.text,
              onPressed: onRefreshPressed,
            ),

          if (showFilter)
            AppButton(
              icon: AppIcons.filter,
              type: AppButtonType.text,
              onPressed: onFilterPressed,
            ),

          if (showExcel)
            AppButton(
              icon: AppIcons.excel,
              type: AppButtonType.text,
              onPressed: onExcelPressed,
            ),

          if (showPdf)
            AppButton(
              icon: AppIcons.pdf,
              type: AppButtonType.text,
              onPressed: onPdfPressed,
            ),

          if (showPrint)
            AppButton(
              icon: AppIcons.print,
              type: AppButtonType.text,
              onPressed: onPrintPressed,
            ),

          const Spacer(),

          //==========================
          // Primary Button
          //==========================
          if (primaryButtonText != null)
            AppButton(
              text: primaryButtonText!,
              icon: primaryButtonIcon ?? AppIcons.add,
              onPressed: onPrimaryPressed,
            ),
        ],
      ),
    );
  }
}
