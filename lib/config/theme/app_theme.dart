import 'package:flutter/material.dart';
import 'package:wms/config/theme/list_colors.dart';

class AppTheme {
  final bool isDarkMode;
  final int indexColor;

  AppTheme({this.isDarkMode = false, this.indexColor = 10});

  ThemeData getTheme() {
    return ThemeData(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorSchemeSeed: indexColor > 0 && indexColor < listColors.length
          ? listColors[indexColor]
          : listColors[0],
    );
  }
}
