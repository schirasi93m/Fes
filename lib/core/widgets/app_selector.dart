import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_sizes.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_style.dart';
import 'app_button.dart';

class AppSelector<T> extends StatefulWidget {
  final String? label;
  final bool requiredField;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final T? value;
  final List<T> items;
  final String Function(T item) itemLabel;
  final String Function(T item)? secondaryItemLabel;
  final String? primaryHeader;
  final String? secondaryHeader;
  final ValueChanged<T?> onChanged;
  final bool showAddButton;
  final bool showEditButton;
  final bool showConfirmButton;
  final VoidCallback? onAddPressed;
  final VoidCallback? onEditPressed;
  final bool searchable;
  final String searchHint;

  const AppSelector({
    super.key,
    required this.label,
    required this.hint,
    this.requiredField = false,
    required this.value,
    required this.items,
    required this.itemLabel,
    this.secondaryItemLabel,
    this.primaryHeader,
    this.secondaryHeader,
    required this.onChanged,
    this.showAddButton = false,
    this.showEditButton = false,
    this.showConfirmButton = true,
    this.onAddPressed,
    this.onEditPressed,
    this.searchable = false,
    this.searchHint = 'جستجو...',
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.autofocus = false,
    this.focusNode,
    this.onTap,
    this.validator,
    this.inputFormatters,
    this.enabled = true,
  });

  @override
  State<AppSelector<T>> createState() => _AppSelectorState<T>();
}

class _AppSelectorState<T> extends State<AppSelector<T>> {
  late final TextEditingController _searchController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _normalize(String value) {
    return value.trim().toLowerCase().replaceAll('ي', 'ی').replaceAll('ك', 'ک');
  }

  InputDecoration _fieldDecoration({Widget? label, Widget? suffixIcon}) {
    return InputDecoration(
      label: label ?? Text(widget.label!),
      hintText: widget.hint,
      prefixIcon: widget.prefixIcon,
      suffixIcon: suffixIcon ?? widget.suffixIcon,
      enabled: widget.enabled,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.textField),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.textField),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.textField),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.textField),
        borderSide: BorderSide(color: AppColors.border),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayValue = widget.value == null
        ? widget.hint!
        : widget.itemLabel(widget.value as T);

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        // The popup should never claim more room than the screen has.
        // This used to force the menu to a fixed 900px (AppSizes.dialogWidth)
        // on every field narrower than that - i.e. on virtually every
        // phone and most tablets, since it fired whenever the field
        // itself was narrower than 900px. The popup rendered half
        // off-screen as a result.
        final maxMenuWidth = screenWidth - (AppSpacing.lg * 2);
        final desiredMenuWidth = constraints.maxWidth.isFinite
            ? (constraints.maxWidth < AppSizes.selectorMenuMinWidth
                  ? AppSizes.selectorMenuMinWidth
                  : constraints.maxWidth)
            : AppSizes.selectorMenuMinWidth;
        final menuWidth = desiredMenuWidth > maxMenuWidth
            ? maxMenuWidth
            : desiredMenuWidth;
        MenuController? menuController;
        final query = _normalize(_searchQuery);
        final filteredItems = query.isEmpty
            ? widget.items
            : widget.items.where((item) {
                return _normalize(widget.itemLabel(item)).contains(query) ||
                    (widget.secondaryItemLabel != null &&
                        _normalize(
                          widget.secondaryItemLabel!(item),
                        ).contains(query));
              }).toList();
        bool activatedByKeyboard = false;
        final itemWidgets = filteredItems.map((item) {
          final isSelected = item == widget.value;

          return Focus(
            onKeyEvent: (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.enter) {
                activatedByKeyboard = true;
              }
              return KeyEventResult.ignored;
            },
            child: GestureDetector(
              onDoubleTap: () {
                widget.onChanged(item);
                menuController?.close();
              },
              child: MenuItemButton(
                style: ButtonStyle(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  ),
                  minimumSize: const WidgetStatePropertyAll(
                    Size.fromHeight(44),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.button),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.resolveWith(
                    (states) =>
                        states.contains(WidgetState.hovered) || isSelected
                        ? AppColors.tableRowSelected
                        : Colors.transparent,
                  ),
                ),
                onPressed: () {
                  widget.onChanged(item);
                  if (activatedByKeyboard) {
                    menuController?.close();
                    activatedByKeyboard = false;
                  }
                },
                closeOnActivate: false,
                child: widget.secondaryItemLabel == null
                    ? Text(
                        widget.itemLabel(item),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodyMedium,
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.itemLabel(item),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 24,
                            color: AppColors.border.withValues(alpha: 0.8),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                widget.secondaryItemLabel!(item),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          );
        }).toList();

        final menuChildren = [
          SizedBox(
            width: menuWidth,
            height: 420,
            child: Column(
              children: [
                if (widget.searchable)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: TextField(
                      controller: _searchController,
                      autofocus: true,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppRadius.textField,
                          ),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                  ),
                if (widget.primaryHeader != null ||
                    widget.secondaryHeader != null)
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.tableHeader,
                      border: Border(
                        bottom: BorderSide(color: AppColors.border),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.primaryHeader ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: AppColors.border.withValues(alpha: 0.8),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              widget.secondaryHeader ?? '',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: filteredItems.isEmpty
                      ? Center(
                          child: Text(
                            'موردی یافت نشد',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.xs,
                          ),
                          itemCount: itemWidgets.length,
                          separatorBuilder: (_, _) => Divider(
                            color: AppColors.border.withValues(alpha: 0.6),
                            height: 1,
                            indent: AppSpacing.md,
                            endIndent: AppSpacing.md,
                          ),
                          itemBuilder: (context, index) => itemWidgets[index],
                        ),
                ),
                if (widget.showAddButton ||
                    widget.showEditButton ||
                    widget.showConfirmButton) ...[
                  Divider(
                    height: 1,
                    color: AppColors.border.withValues(alpha: 0.6),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.xs,
                      children: [
                        if (widget.showConfirmButton)
                          AppButton(
                            text: 'تایید',
                            icon: Icons.check,
                            size: AppButtonSize.small,
                            type: AppButtonType.filled,
                            onPressed: () {
                              menuController?.close();
                            },
                          ),
                        if (widget.showAddButton)
                          AppButton(
                            text: 'جدید',
                            icon: Icons.add,
                            size: AppButtonSize.small,
                            type: AppButtonType.text,
                            onPressed: widget.onAddPressed,
                          ),
                        if (widget.showEditButton)
                          AppButton(
                            text: 'ویرایش',
                            icon: Icons.edit_outlined,
                            size: AppButtonSize.small,
                            type: AppButtonType.text,
                            enabled: widget.value != null,
                            onPressed: widget.value == null
                                ? null
                                : widget.onEditPressed,
                          ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ];
        return MenuAnchor(
          alignmentOffset: const Offset(0, 4),
          crossAxisUnconstrained: false,
          style: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.surface),
            surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
            elevation: const WidgetStatePropertyAll(8),
            minimumSize: WidgetStatePropertyAll(Size(menuWidth, 48)),
            maximumSize: WidgetStatePropertyAll(Size(menuWidth, 520)),
            padding: const WidgetStatePropertyAll(EdgeInsets.zero),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.card),
                side: BorderSide(color: AppColors.border),
              ),
            ),
          ),
          menuChildren: menuChildren,
          builder: (context, controller, child) {
            menuController = controller;
            return InkWell(
              onTap: widget.enabled
                  ? () {
                      if (controller.isOpen) {
                        controller.close();
                      } else {
                        controller.open();
                      }
                    }
                  : null,
              borderRadius: BorderRadius.circular(AppRadius.textField),
              child: InputDecorator(
                decoration: _fieldDecoration(
                  label: widget.label == null
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(widget.label!),
                            if (widget.requiredField)
                              const Text(
                                ' *',
                                style: TextStyle(color: AppColors.danger),
                              ),
                          ],
                        ),
                  suffixIcon: Icon(
                    controller.isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: AppSizes.iconMd,
                    color: widget.enabled
                        ? AppColors.textSecondary
                        : AppColors.textDisabled,
                  ),
                ),
                child: Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: widget.value == null
                        ? AppColors.textSecondary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
