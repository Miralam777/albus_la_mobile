part of 'app_themes.dart';

class WidgetThemes {
  WidgetThemes._();
  // TODO: clean

  //! light colors
  static const Color lightPrimaryColor = Color(0xFF004BA6);
  static const Color lightSecondaryColor = Color(0xFF1E67C0);
  static const Color lightScaffoldBackgroundColor = Color(0xFFE3E3E3);
  static const Color lightCardColor = Color(0xFFE0E5EB);
  static const Color lightSecondaryHeaderColor = Color(0x78000000);
  static const Color _lightPrimaryContainer = Color(0xFFFFFFFF);
  static const Color _lightSecondaryContainer = Color(0xFFF7F7F7);
  static const Color _lightTertiaryContainer = Color(0xFFF0F0F0);
  static const Color _lightErrorContainer = Color(0xFFFF9891);
  static const Color _lightErrorColor = Color(0xFFB00020);

  //! dark colors
  static const Color darkPrimaryColor = Color(0xFF004BA6);
  static const Color darkSecondaryColor = Color(0xFF1E67C0);
  static const Color darkScaffoldBackgroundColor = Color(0xFF111010);
  static const Color darkCardColor = Color(0xFF191E24);
  static const Color darkSecondaryHeaderColor = Color(0x78FFFFFF);
  static const Color _darkPrimaryContainer = Color(0xFF323232);
  static const Color _darkSecondaryContainer = Color(0xFF2B2B2B);
  static const Color _darkTertiaryContainer = Color(0xFF1B1B1B);
  static const Color _darkErrorContainer = Color(0xFFA0281F);
  static const Color _darkErrorColor = Color(0xFFCF6679);

  //! colors
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _black = Color(0xFF000000);

  //! brightness
  static Brightness brightness({bool isDark = false}) =>
      isDark ? Brightness.dark : Brightness.light;

  //! color scheme
  static ColorScheme colorScheme({bool isDark = false}) => ColorScheme(
    brightness: brightness(isDark: isDark),
    primary: isDark ? darkPrimaryColor : lightPrimaryColor,
    onPrimary: _white,
    secondary: isDark ? darkSecondaryColor : lightSecondaryColor,
    onSecondary: isDark ? _white : _black,
    error: isDark ? _darkErrorColor : _lightErrorColor,
    onError: isDark ? _black : _white,
    surface: isDark ? const Color(0xFF121212) : _white,
    onSurface: isDark ? _white : _black,
    outline: isDark ? _darkSecondaryContainer : _lightSecondaryContainer,
    shadow: isDark ? const Color(0xFF000000) : const Color(0x82000000),
    primaryContainer: isDark ? _darkPrimaryContainer : _lightPrimaryContainer,
    secondaryContainer: isDark
        ? _darkSecondaryContainer
        : _lightSecondaryContainer,
    tertiaryContainer: isDark
        ? _darkTertiaryContainer
        : _lightTertiaryContainer,
    errorContainer: isDark ? _darkErrorContainer : _lightErrorContainer,
    onErrorContainer: isDark ? _white : _black,
  );

  //! text styles
  static TextTheme textTheme({bool isDark = false}) => TextTheme(
    titleLarge: _titleLarge(isDark: isDark),
    titleMedium: _titleMedium(isDark: isDark),
    titleSmall: _titleSmall(isDark: isDark),
    bodySmall: _bodySmall(isDark: isDark),
    bodyMedium: _bodyMedium(isDark: isDark),
    bodyLarge: _bodyLarge(isDark: isDark),
  );

  //* bodies
  static TextStyle _bodySmall({bool isDark = false}) => TextStyle(
    fontSize: 12.0.sp,
    color: isDark ? _white : _black,
    overflow: textOverflowEllipsis,
    fontFamily: fontFamilyBarlowSemi,
  );

  static TextStyle _bodyMedium({bool isDark = false}) =>
      _bodySmall(isDark: isDark).copyWith(fontSize: 14.0.sp);

  static TextStyle _bodyLarge({bool isDark = false}) =>
      _bodySmall(isDark: isDark).copyWith(fontSize: 16.0.sp);

  //* titles
  static TextStyle _titleSmall({bool isDark = false}) => TextStyle(
    fontSize: 14.0.sp,
    color: isDark ? _white : _black,
    fontWeight: FontWeight.bold,
    overflow: textOverflowEllipsis,
    fontFamily: fontFamilyBarlowSemi,
  );

  static TextStyle _titleMedium({bool isDark = false}) =>
      _titleSmall(isDark: isDark).copyWith(fontSize: 16.0.sp);

  static TextStyle _titleLarge({bool isDark = false}) =>
      _titleSmall(isDark: isDark).copyWith(fontSize: 22.0.sp);

  //! app bar
  static AppBarTheme appBarTheme({bool isDark = false}) => AppBarTheme(
    backgroundColor: isDark
        ? darkScaffoldBackgroundColor.withValues(alpha: 0.95)
        : lightScaffoldBackgroundColor.withValues(alpha: 0.95),
    iconTheme: iconTheme(isDark: isDark),
    titleTextStyle: _titleSmall(isDark: isDark).copyWith(fontSize: 20.0.sp),
    centerTitle: true,
  );

  //! drawer
  /*   static const DrawerThemeData drawerTheme = DrawerThemeData(
    backgroundColor: darkScaffoldBackgroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(kRadius20)),
    ),
  ); */

  /*   static const sliderTheme = SliderThemeData(
    activeTrackColor: Colors.red,
    activeTickMarkColor: Colors.red,
  ); */

  /*   static const RadioThemeData radioThemeData = RadioThemeData(
    fillColor: WidgetStatePropertyAll(darkPrimaryColor),
  ); */

  //! bottom sheet theme
  static BottomSheetThemeData bottomSheetTheme({bool isDark = false}) =>
      BottomSheetThemeData(
        backgroundColor: isDark
            ? darkScaffoldBackgroundColor
            : lightScaffoldBackgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(K.rl)),
          side: BorderSide(
            color: colorScheme(isDark: isDark).outline,
            width: K.bm,
          ),
        ),
      );

  //! list tile
  static ListTileThemeData listTileTheme({
    bool isDark = false,
  }) => ListTileThemeData(
    tileColor: colorScheme(isDark: isDark).tertiaryContainer,
    selectedTileColor: colorScheme(isDark: isDark).primaryContainer,
    titleTextStyle: _titleMedium(isDark: isDark),
    subtitleTextStyle: _bodyMedium(isDark: isDark).copyWith(
      color: isDark ? darkSecondaryHeaderColor : lightSecondaryHeaderColor,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 5.0.h),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(K.rm)),
  );

  //! text field
  static InputDecorationTheme inputDecorationTheme({bool isDark = false}) =>
      InputDecorationTheme(
        // fillColor: colorScheme(isDark: isDark).secondaryContainer,
        fillColor: colorScheme(isDark: isDark).tertiaryContainer,
        hintStyle: TextStyle(
          fontSize: 16.0.sp,
          fontFamily: fontFamilyBarlowSemi,
          color: isDark ? Colors.white60 : Colors.black45,
        ),
        labelStyle: TextStyle(
          color: isDark ? Colors.white60 : Colors.black45,
          fontSize: 16.0.sp,
          fontFamily: fontFamilyBarlowSemi,
        ),
        errorStyle: _bodySmall(isDark: isDark).copyWith(
          overflow: TextOverflow.clip,
          color: colorScheme(isDark: isDark).error,
        ),
        errorMaxLines: 3,
        helperStyle: _bodySmall(
          isDark: isDark,
        ).copyWith(overflow: TextOverflow.clip),
        helperMaxLines: 3,
        floatingLabelStyle: const TextStyle(fontFamily: fontFamilyBarlowSemi),
        floatingLabelAlignment: FloatingLabelAlignment.center,
        border: InputBorder.none,
        iconColor: colorScheme(isDark: isDark).secondary,
        prefixIconColor: colorScheme(isDark: isDark).secondary,
        suffixIconColor: WidgetStateColor.resolveWith(
          (states) => states.contains(WidgetState.focused)
              ? colorScheme(isDark: isDark).secondary
              : isDark
              ? Colors.white60.withValues(alpha: 0.5)
              : Colors.black45.withValues(alpha: 0.5),
        ),
        focusedBorder: _outlineInputBorder(
          colorScheme(isDark: isDark).primary,
          radius: 15,
        ),
        enabledBorder: _outlineInputBorder(
          isDark
              ? Colors.white60.withValues(alpha: 0.2)
              : Colors.black45.withValues(alpha: 0.2),
        ),
        errorBorder: _outlineInputBorder(colorScheme(isDark: isDark).error),
        focusedErrorBorder: _outlineInputBorder(
          colorScheme(isDark: isDark).error,
          radius: 15,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 15.0.w,
          vertical: 5.0.h,
        ),
      );

  static OutlineInputBorder _outlineInputBorder(
    Color color, {
    double radius = K.rm,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(color: color, width: K.bs),
  );

  //! text button
  static TextButtonThemeData textButtonTheme({bool isDark = false}) =>
      TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(
            isDark ? darkSecondaryColor : lightSecondaryColor,
          ),
          iconSize: WidgetStatePropertyAll(iconTheme(isDark: isDark).size),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
          ),
          backgroundColor: WidgetStatePropertyAll(
            colorScheme(isDark: isDark).secondary.withValues(alpha: 0.1),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
          ),
          textStyle: WidgetStatePropertyAll(_titleSmall(isDark: isDark)),
        ),
      );

  //! icon
  static IconThemeData iconTheme({bool isDark = false}) =>
      IconThemeData(color: isDark ? _white : _black, size: 24.0.r);

  //! icon button
  static IconButtonThemeData iconButtonTheme({bool isDark = false}) =>
      IconButtonThemeData(
        style: ButtonStyle(iconSize: WidgetStatePropertyAll(24.0.r)),
      );

  //! card
  static CardThemeData cardTheme({bool isDark = false}) => CardThemeData(
    color: isDark ? darkCardColor : lightCardColor,
    shadowColor: colorScheme(isDark: isDark).shadow,
    margin: EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 4.0.w),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(K.rm)),
  );

  //! elevated button
  static ElevatedButtonThemeData elevatedButtonTheme({bool isDark = false}) =>
      ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(
            colorScheme(isDark: isDark).primary,
          ),
          foregroundColor: const WidgetStatePropertyAll(_white),
          iconColor: const WidgetStatePropertyAll(_white),
          iconSize: WidgetStatePropertyAll(iconTheme(isDark: isDark).size),
          padding: WidgetStatePropertyAll(
            EdgeInsets.symmetric(vertical: 4.0.h, horizontal: 10.0.w),
          ),
          textStyle: WidgetStatePropertyAll(
            TextStyle(
              fontSize: 15.0.sp,
              fontWeight: FontWeight.bold,
              overflow: textOverflowEllipsis,
            ),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(K.rm)),
          ),
        ),
      );

  //! outlined button
  /*   static final OutlinedButtonThemeData outlinedButtonTheme =
      OutlinedButtonThemeData(
    style: ButtonStyle(
      side: const WidgetStatePropertyAll(BorderSide(color: Colors.white10)),
      foregroundColor: const WidgetStatePropertyAll(Colors.white),
      textStyle: WidgetStatePropertyAll(
        TextStyle(
          fontSize: 14.0.sp,
          fontFamily: fontFamilyBarlowSemi,
          overflow: textOverflowEllipsis,
        ),
      ),
      backgroundColor: const WidgetStatePropertyAll(Color(0xff0A8110)),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(krm),
        ),
      ),
    ),
  ); */

  //! snack bar
  /*   static SnackBarThemeData snackBarTheme({bool isDark = false}) =>
      SnackBarThemeData(
        showCloseIcon: true,
        backgroundColor: _darkTertiaryContainer,
        contentTextStyle:
            _bodyMedium(isDark: isDark).copyWith(overflow: TextOverflow.clip),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(krm)),
        behavior: SnackBarBehavior.floating,
      ); */

  //! circle avatar
  /*   static ChipThemeData chipTheme({bool isDark = false}) => ChipThemeData(
        // brightness: Brightness.dark,
        backgroundColor: darkSecondaryColor,
        iconTheme: iconTheme().copyWith(color: Colors.black),
      );
 */

  //! floating action button
  /*   static FloatingActionButtonThemeData fABThemeData({bool isDark = false}) =>
      FloatingActionButtonThemeData(
        // brightness: Brightness.dark,
        // backgroundColor: darkSecondaryColor,
        // iconTheme: iconTheme().copyWith(color: Colors.black),
        backgroundColor: isDark ? darkSecondaryColor : lightSecondaryColor,
        foregroundColor: _white,
      ); */

  //! checkbox
  static CheckboxThemeData checkboxTheme({bool isDark = false}) =>
      CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(K.rs),
        ),
        fillColor: WidgetStatePropertyAll(
          colorScheme(isDark: isDark).secondaryContainer,
        ),
      );

  //! popup menu button
  static PopupMenuThemeData popupMenuTheme({bool isDark = false}) =>
      PopupMenuThemeData(
        color: isDark
            ? darkScaffoldBackgroundColor
            : lightScaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(K.rm)),
        ),
      );

  //! time picker
  /* static TimePickerThemeData timePickerTheme({bool isDark = false}) =>
      TimePickerThemeData(
        hourMinuteColor: colorScheme(isDark: isDark).tertiaryContainer,
      ); */

  //! divider theme
  static DividerThemeData dividerTheme({bool isDark = false}) =>
      DividerThemeData(
        color: colorScheme(isDark: isDark).secondaryContainer,
        space: 0.0,
      );

  //! dialog theme
  // static DialogTheme dialogTheme({bool isDark = false}) => DialogTheme();

  //! configs
  static const TextOverflow textOverflowEllipsis = TextOverflow.ellipsis;
  // TODO font generated
  static const String fontFamilyBarlowSemi = 'FontFamily.barlowSemiCondensed';

  static const AndroidOverscrollIndicator androidOverscrollIndicator =
      AndroidOverscrollIndicator.stretch;

  static const PageTransitionsTheme pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );
}
