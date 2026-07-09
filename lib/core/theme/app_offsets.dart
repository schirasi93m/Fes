import 'package:flutter/material.dart';
class AppOffsets {
  AppOffsets._();

  // ===========================
  // Shadows
  // ===========================

  /// Card Shadow
  static const Offset cardShadow = Offset(0, 4);

  /// Button Shadow
  static const Offset buttonShadow = Offset(0, 3);

  /// Dialog Shadow
  static const Offset dialogShadow = Offset(0, 10);

  /// Popup/Menu Shadow
  static const Offset popupShadow = Offset(0, 6);

  // ===========================
  // Components
  // ===========================

  /// Tooltip
  static const Offset tooltip = Offset(0, 8);

  /// Dropdown
  static const Offset dropdown = Offset(0, 4);

  /// Popup Menu
  static const Offset popupMenu = Offset(0, 6);

  /// Context Menu
  static const Offset contextMenu = Offset(0, 6);

  /// SnackBar
  static const Offset snackBar = Offset(0, -16);

  // ===========================
  // Animation
  // ===========================

  /// Slide From Top
  static const Offset slideFromTop = Offset(0, -1);

  /// Slide From Bottom
  static const Offset slideFromBottom = Offset(0, 1);

  /// Slide From Left
  static const Offset slideFromLeft = Offset(-1, 0);

  /// Slide From Right
  static const Offset slideFromRight = Offset(1, 0);

  /// No Offset
  static const Offset zero = Offset.zero;
}