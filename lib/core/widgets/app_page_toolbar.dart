import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_icons.dart';
import '../theme/app_sizes.dart';
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
  final bool showSreachBox;

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
    this.showSreachBox = true,

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
      padding: EdgeInsets.all(
        MediaQuery.sizeOf(context).width < AppSizes.formStackBreakpoint
            ? AppSpacing.md
            : AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact =
              constraints.maxWidth < AppSizes.toolbarCompactBreakpoint;
          final isNarrow =
              constraints.maxWidth < AppSizes.headerCompactBreakpoint;

          final search = showSreachBox
              ? isCompact
                    ? SizedBox(
                        width: isNarrow
                            ? constraints.maxWidth
                            : constraints.maxWidth.clamp(
                                AppTableSizes.actions + AppTableSizes.code,
                                AppSizes.notificationWidth,
                              ),
                        child: AppSearchBox(
                          controller: searchController!,
                          hintText: searchHint,
                          onChanged: onSearchChanged,
                        ),
                      )
                    : Flexible(
                        child: AppSearchBox(
                          controller: searchController!,
                          hintText: searchHint,
                          onChanged: onSearchChanged,
                        ),
                      )
              : null;

          final actions = [
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
          ];

          final primaryButton = primaryButtonText == null
              ? null
              : AppButton(
                  text: primaryButtonText!,
                  icon: primaryButtonIcon ?? AppIcons.add,
                  onPressed: onPrimaryPressed,
                );
          final searchGap = searchController == null
              ? null
              : const SizedBox(width: AppSpacing.md);

          if (isCompact) {
            return Wrap(
              alignment: WrapAlignment.start,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                ?search,
                ...actions,
                ?primaryButton,
              ],
            );
          }

          return Row(
            children: [
              ?search,
              ?searchGap,
              ...actions,
              const Spacer(),
              ?primaryButton,
            ],
          );
        },
      ),
    );
  }
}
