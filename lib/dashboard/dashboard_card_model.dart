import 'package:flutter/material.dart';

class DashboardCardModel {
  final String title;
  final String value;
  final Widget? icon;
  final Widget? footer;
  final Color? color;

  const DashboardCardModel({
    required this.title,
    required this.value,
    this.icon,
    this.footer,
    this.color,
  });
}