import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:new_project_fes/core/models/app_table_column.dart';
import 'package:new_project_fes/core/theme/app_spacing.dart';
import 'package:new_project_fes/core/widgets/app_button.dart';
import 'package:new_project_fes/core/widgets/app_card.dart';
import 'package:new_project_fes/core/widgets/app_dialog.dart';
import 'package:new_project_fes/core/widgets/app_select/app_select.dart';
import 'package:new_project_fes/core/widgets/app_select/app_select_item.dart';
import 'package:new_project_fes/core/widgets/app_table/app_table.dart';
import 'package:new_project_fes/core/widgets/app_text_field.dart';
import 'package:new_project_fes/core/widgets/status_badge.dart';
import 'package:new_project_fes/core/theme/app_icons.dart';

class ComponentShowcase extends StatefulWidget {
  const ComponentShowcase({super.key});

  @override
  State<ComponentShowcase> createState() => _ComponentShowcaseState();
}

class _ComponentShowcaseState extends State<ComponentShowcase> {
  int? selectedType = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Component Showcase")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(LucideIcons.plus, size: 40),
            //-------------------------------------
            //     Buttons
            //---------------------------------------
            _title("Buttons"),

            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                AppButton(text: "ثبت", onPressed: () {}),
                AppButton(text: "ویرایش", onPressed: () {}),
                AppButton(text: "حذف", onPressed: () {}),
                AppButton(
                  text: "نمایش دیالوگ",
                  onPressed: () {
                    AppDialog.show(
                      context: context,
                      title: "نمونه دیالوگ",
                      content: const Text("این اولین دیالوگ پروژه است."),
                      actions: [
                        AppButton(
                          text: "بستن",
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //      Text Fields
            //---------------------------------------
            _title("Text Fields"),

            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: const [
                SizedBox(width: 250, child: AppTextField(label: "نام")),
                SizedBox(width: 250, child: AppTextField(hint: "جستجو...")),
                SizedBox(
                  width: 250,
                  child: AppTextField(label: "رمز عبور", obscureText: true),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //      DropDownList
            //-------------------------------------
            _title("DropDownList"),

            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                SizedBox(
                  width: 250,
                  child: AppSelect<int>(
                    label: "نوع کپسول",
                    dialogTitle: "انتخاب نوع کپسول",
                    hint: "انتخاب کنید",
                    value: selectedType,
                    showAddButton: true,
                    showEditButton: true,
                    items: const [
                      AppSelectItem(value: 1, title: "پودر و گاز"),
                      AppSelectItem(value: 2, title: "CO₂"),
                      AppSelectItem(value: 3, title: "فوم"),
                    ],
                    onChanged: (value) {
                      setState(() {
                        selectedType = value;
                      });
                    },
                  ),
                ),

                SizedBox(
                  width: 250,
                  child: AppSelect<int>(
                    label: "Select غیرفعال",
                    dialogTitle: "انتخاب",
                    value: 1,
                    enabled: false,
                    items: const [AppSelectItem(value: 1, title: "پودر و گاز")],
                    onChanged: (_) {},
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //      Status Badges
            //-------------------------------------
            _title("Status Badges"),

            Wrap(
              spacing: AppSpacing.lg,
              children: const [
                StatusBadge(text: "موفق", type: StatusBadgeType.success),
                StatusBadge(text: "خطا", type: StatusBadgeType.error),
                StatusBadge(text: "اطلاعات", type: StatusBadgeType.info),
                StatusBadge(text: "هشدار", type: StatusBadgeType.warning),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //      Icon Buttons
            //---------------------------------------
            _title("Icon Buttons"),
            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: [
                AppButton(text: "افزودن", icon: AppIcons.add, onPressed: () {}),

                AppButton(
                  text: "ویرایش",
                  icon: AppIcons.edit,
                  onPressed: () {},
                ),

                AppButton(text: "حذف", icon: AppIcons.delete, onPressed: () {}),

                AppButton(text: "ذخیره", icon: AppIcons.save, onPressed: () {}),

                AppButton(
                  text: "جستجو",
                  icon: AppIcons.search,
                  onPressed: () {},
                ),

                AppButton(
                  text: "رفرش",
                  icon: AppIcons.refresh,
                  onPressed: () {},
                ),

                AppButton(
                  text: "پرینت",
                  icon: AppIcons.print,
                  onPressed: () {},
                ),

                AppButton(
                  text: "تنظیمات",
                  icon: AppIcons.settings,
                  onPressed: () {},
                ),

                AppButton(text: "ورود", icon: AppIcons.login, onPressed: () {}),

                AppButton(
                  text: "خروج",
                  icon: AppIcons.logout,
                  onPressed: () {},
                ),

                AppButton(icon: AppIcons.add, onPressed: () {}),

                AppButton(icon: AppIcons.edit, onPressed: () {}),

                AppButton(icon: AppIcons.delete, onPressed: () {}),

                AppButton(icon: AppIcons.search, onPressed: () {}),

                AppButton(icon: AppIcons.settings, onPressed: () {}),

                AppButton(icon: AppIcons.add, onPressed: () {}),

                AppButton(text: "افزودن", icon: AppIcons.add, onPressed: () {}),

                AppButton(text: "افزودن", onPressed: () {}),

                AppButton(
                  icon: AppIcons.search,
                  type: AppButtonType.outlined,
                  onPressed: () {},
                ),

                AppButton(
                  icon: AppIcons.delete,
                  type: AppButtonType.text,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //      Cards
            //---------------------------------------
            _title("Cards"),

            Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              children: const [
                SizedBox(
                  width: 220,
                  child: AppCard(title: "مشتریان", value: "1250"),
                ),
                SizedBox(
                  width: 220,
                  child: AppCard(title: "کپسول‌ها", value: "4580"),
                ),
                SizedBox(
                  width: 220,
                  child: AppCard(title: "سرویس‌ها", value: "315"),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
            //-------------------------------------
            //     Table
            //---------------------------------------
            _title("Table"),

            AppTable(
              columns: const [
                AppTableColumn(title: "نام", width: 220),
                AppTableColumn(title: "موبایل", width: 180),
                AppTableColumn(title: "شرکت", width: 220),
                AppTableColumn(title: "وضعیت", width: 120),
                AppTableColumn(title: "عملیات", width: 120),
              ],
              rows: [
                const [
                  Text("مصطفی شیرازی"),
                  Text("09121234567"),
                  Text("ایمن شهر"),
                  
                  Text("فعال"),
                  Icon(Icons.edit),
                ],
                const [
                  Text("علی رضایی"),
                  Text("09123334444"),
                  Text("شرکت آلفا"),
                  Text("غیرفعال"),
                  Icon(Icons.edit),
                ],
                const [
                  Text("رضا محمدی"),
                  Text("09125556666"),
                  Text("شرکت بتا"),
                  Text("فعال"),
                  Icon(Icons.edit),
                ],
              ],
            ),

            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }
}
