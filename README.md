diff --git a/README.md b/README.md
index 8136527725889a44050c9575d0ac04468b91a919..3412cedbc68f0205a93cafd2eae053119fcdd366 100644
--- a/README.md
+++ b/README.md
@@ -1,17 +1,39 @@
-# new_project_fes
+# FES
 
-A new Flutter project.
+پنل وب/دسکتاپ فارسی برای مدیریت تجهیزات ایمنی و آتش‌نشانی.
 
-## Getting Started
+## امکانات فعلی
 
-This project is a starting point for a Flutter application.
+- پوستهٔ راست‌به‌چپ با سایدبار، هدر و فوتر.
+- نمایش، جست‌وجو، فیلتر مشتریان فعال، افزودن و ویرایش مشتری در حافظهٔ برنامه.
+- مجموعه‌ای از کامپوننت‌های قابل‌استفادهٔ رابط کاربری، مانند جدول، دکمه، فیلد متن و انتخابگر.
 
-A few resources to get you started if this is your first Flutter project:
+> داده‌های مشتریان فعلاً محلی هستند و با بستن یا بارگذاری مجدد برنامه حفظ نمی‌شوند.
 
-- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
-- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
-- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)
+## اجرا
 
-For help getting started with Flutter development, view the
-[online documentation](https://docs.flutter.dev/), which offers tutorials,
-samples, guidance on mobile development, and a full API reference.
+1. Flutter SDK سازگار با Dart `^3.12.1` را نصب کنید.
+2. وابستگی‌ها را دریافت کنید:
+
+   ```bash
+   flutter pub get
+   ```
+
+3. بررسی و اجرای تست‌ها:
+
+   ```bash
+   flutter analyze
+   flutter test
+   ```
+
+4. اجرای برنامه در مرورگر:
+
+   ```bash
+   flutter run -d chrome
+   ```
+
+## ساختار اصلی
+
+- `lib/core`: تم و کامپوننت‌های مشترک رابط کاربری.
+- `lib/dashboard`: پوسته و ناوبری اصلی برنامه.
+- `lib/features/customers`: مدل، صفحه و فرم مدیریت مشتریان.
