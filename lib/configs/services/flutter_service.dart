import 'package:flutter/services.dart';

class FlutterService {
  FlutterService._();

  static void setDefaultPreferredOrientations() =>
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  static void setSetSystemUIOverlayStyle(bool isDarkTheme) =>
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: isDarkTheme
              ? const Color(0xff111010).withValues(alpha: 0.1)
              : const Color(0xFFE3E3E3).withValues(alpha: 0.1),
          systemNavigationBarIconBrightness:
              isDarkTheme ? Brightness.light : Brightness.dark,
        ),
      );

  static void setEnabledSystemUIMode() => SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );
}
