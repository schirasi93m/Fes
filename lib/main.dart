import 'package:flutter/material.dart';
import 'package:new_project_fes/Core/Theme/app_theme.dart';
import 'package:new_project_fes/dashboard/main_screen.dart';
//import 'package:new_project_fes/dashboard/main_screen.dart';
//import 'package:new_project_fes/playground/component_playground.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Date and Time Pickers',
      locale: const Locale("fa", "IR"),
      supportedLocales: const [Locale("fa", "IR"), Locale("en", "US")],
      localizationsDelegates: const [
        // Add Localization
        PersianMaterialLocalizations.delegate,
        PersianCupertinoLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.lightTheme,
      /* ThemeData(
        
        fontFamily: 'IranSans',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 0, 0)),
      ),*/
      //  home: const MyPersianCalendar(), //
      home: const MainScreen(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ایمن شهر'),
      ),
      body: const Center(
        child: Text(
          'سلام مصطفی! حالا محیط آماده کدنویسی توست.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
