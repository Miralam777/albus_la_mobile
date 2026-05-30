import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MediaHelper {
  MediaHelper._();

// TODO: clean
  static double h(BuildContext context) => MediaQuery.of(context).size.height;

  static double w(BuildContext context) => MediaQuery.of(context).size.width;

  static double get appBarH => kToolbarHeight;

  static double statusBarH(BuildContext context) =>
      MediaQuery.of(context).viewPadding.top;

  /// status and app bar height with app bar in widget
  static double statusAndAppBarH(BuildContext context) =>
      statusBarH(context) + appBarH;

  /// status and app bar height without app bar in widget
  static double statusAndAppBarHWithoutAppBar(BuildContext context) =>
      MediaQuery.of(context).padding.top;

  static double keyboardH(BuildContext context) =>
      MediaQuery.of(context).viewInsets.bottom;

  /// Get height of system navigation bar (Android)
  static double androidBtmNavBarH(BuildContext context) =>
      MediaQuery.of(context).viewPadding.bottom;

  static bool isBrightnessDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static void closeKeyboard(BuildContext context) =>
      FocusScope.of(context).requestFocus(FocusNode());

  static double get btmNBarH => kBottomNavigationBarHeight;

  /// view list bottom padding => 70.0.h
  static double get viewListBtmPadding => 70.0.h;

  static double getBottomInsets(BuildContext context) {
    if (keyboardH(context) > androidBtmNavBarH(context)) {
      return keyboardH(context) - androidBtmNavBarH(context);
    }
    return 0;
  }

  // static bool isTablet(BuildContext context) =>
  // MediaQuery.of(context).size.width > kMaxWidth;

  // static bool isTextLTR(BuildContext context) =>
  // Directionality.of(context) == TextDirection.ltr;
}
