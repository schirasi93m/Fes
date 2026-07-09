import 'package:flutter/material.dart';

class AppSelectItem<T> {
  final T value;
  final String title;

  final String? subtitle;

  final Widget? leading;
  final Widget? trailing;

  final bool enabled;
  final bool visible;

  const AppSelectItem({
    required this.value,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.visible = true,
  });
}
