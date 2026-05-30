import 'package:albus_la_mobile/constants/icons.dart';

import '/constants/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'widget_themes.dart';

class AppThemes {
  AppThemes._();

  //! light theme
  static final ThemeData lightTheme = _themeData();

  //! dark theme
  static final ThemeData darkTheme = _themeData(isDark: true);

  static ThemeData _themeData({isDark = false}) => ThemeData(
    // TODO: remove this
    // platform: TargetPlatform.iOS,
    useMaterial3: true,
    brightness: WidgetThemes.brightness(isDark: isDark),
    primaryColor: isDark
        ? WidgetThemes.darkPrimaryColor
        : WidgetThemes.lightPrimaryColor,
    scaffoldBackgroundColor: isDark
        ? WidgetThemes.darkScaffoldBackgroundColor
        : WidgetThemes.lightScaffoldBackgroundColor,
    cardColor: isDark
        ? WidgetThemes.darkCardColor
        : WidgetThemes.lightCardColor,
    splashColor: isDark
        ? WidgetThemes.darkPrimaryColor.withValues(alpha: 0.4)
        : WidgetThemes.lightPrimaryColor.withValues(alpha: 0.4),
    hintColor: isDark
        ? WidgetThemes.darkPrimaryColor
        : WidgetThemes.lightPrimaryColor,
    secondaryHeaderColor: isDark
        ? WidgetThemes.darkSecondaryHeaderColor
        : WidgetThemes.lightSecondaryHeaderColor,

    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: WidgetThemes.colorScheme(isDark: isDark),
    textTheme: WidgetThemes.textTheme(isDark: isDark),
    appBarTheme: WidgetThemes.appBarTheme(isDark: isDark),
    // drawerTheme: WidgetThemes.drawerTheme,
    // sliderTheme: DarkThemeData.sliderTheme,
    // radioTheme: WidgetThemes.radioThemeData,
    bottomSheetTheme: WidgetThemes.bottomSheetTheme(isDark: isDark),
    listTileTheme: WidgetThemes.listTileTheme(isDark: isDark),
    inputDecorationTheme: WidgetThemes.inputDecorationTheme(isDark: isDark),
    textButtonTheme: WidgetThemes.textButtonTheme(isDark: isDark),
    iconTheme: WidgetThemes.iconTheme(isDark: isDark),
    iconButtonTheme: WidgetThemes.iconButtonTheme(isDark: isDark),
    cardTheme: WidgetThemes.cardTheme(isDark: isDark),
    elevatedButtonTheme: WidgetThemes.elevatedButtonTheme(isDark: isDark),
    // outlinedButtonTheme: WidgetThemes.outlinedButtonTheme,
    // snackBarTheme: WidgetThemes.snackBarTheme(isDark: isDark),
    // chipTheme: WidgetThemes.chipTheme(isDark: isDark),
    // floatingActionButtonTheme: WidgetThemes.fABThemeData(isDark: isDark),
    checkboxTheme: WidgetThemes.checkboxTheme(isDark: isDark),
    popupMenuTheme: WidgetThemes.popupMenuTheme(isDark: isDark),
    dividerTheme: WidgetThemes.dividerTheme(isDark: isDark),
    //  timePickerTheme: WidgetThemes.timePickerTheme(isDark: isDark),
    // dialogTheme: WidgetThemes.dialogTheme(isDark: isDark),
    pageTransitionsTheme: WidgetThemes.pageTransitionsTheme,
  );
}
