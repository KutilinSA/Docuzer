import 'package:flutter/material.dart';

class Themes {
  static const Duration defaultAnimationDuration = Duration(milliseconds: 250);
  static const Curve defaultAnimationCurve = Curves.easeOutCubic;
  static const Duration appearanceAnimationDuration = Duration(milliseconds: 1000);
  static const Curve appearanceAnimationCurve = Curves.easeOutCubic;

  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(16, 16, 16, 24);
  static const EdgeInsets listPadding = EdgeInsets.all(8);

  static const List<BoxShadow> downShadow = [
    BoxShadow(color: Color(0x1914375F), offset: Offset(2, 4), blurRadius: 9, spreadRadius: -2),
  ];

  static const List<BoxShadow> upShadow = [
    BoxShadow(color: Colors.black12, offset: Offset(0, -2), blurRadius: 14),
  ];

  static const colorGrey = Color(0xFF737373);

  static const _colorLightBlue = Color.fromRGBO(236, 243, 243, 1);
  static const _colorPeach = Color.fromRGBO(217, 177, 169, 1);
  static const _colorOrange = Color.fromRGBO(211, 144, 59, 1);
  static const _colorDarkBlue = Color.fromRGBO(20, 55, 95, 1);
  static const _colorError = Color.fromRGBO(219, 62, 62, 1);

  static const TextStyle _defaultTextStyle = TextStyle(
    fontStyle: FontStyle.normal,
    color: _colorDarkBlue,
    fontWeight: FontWeight.w400,
    fontFamily: 'SFProDisplay',
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: _colorLightBlue,
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: _colorOrange, secondaryContainer: _colorPeach),
    primaryColor: _colorLightBlue,
    primaryColorDark: _colorDarkBlue,

    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    fontFamily: 'SFProDisplay',

    errorColor: _colorError,

    dividerColor: const Color(0xffefefef),
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      toolbarHeight: 56,
      titleTextStyle: _defaultTextStyle.copyWith(fontSize: 20, color: _colorDarkBlue, fontWeight: FontWeight.w600),
      iconTheme: const IconThemeData(
        color: _colorDarkBlue,
        size: 24,
      ),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: _colorPeach,
    ),

    scrollbarTheme: ScrollbarThemeData(
      isAlwaysShown: false,
      trackColor: MaterialStateProperty.all<Color>(_colorDarkBlue.withOpacity(0.2)),
      thumbColor: MaterialStateProperty.all<Color>(_colorDarkBlue.withOpacity(0.2)),
      radius: const Radius.circular(8),
    ),

    sliderTheme: const SliderThemeData(
      activeTrackColor: _colorOrange,
      inactiveTrackColor: _colorLightBlue,
      thumbColor: _colorOrange,
      overlayColor: Colors.transparent,
    ),

    iconTheme: const IconThemeData(color: _colorDarkBlue),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedIconTheme: IconThemeData(
        size: 24,
        color: _colorOrange,
      ),
      unselectedIconTheme: IconThemeData(
        size: 24,
        color: Colors.grey,
      ),
    ),

    /**
     * Text theme. For sizes use only copyWith
     */
    textTheme: TextTheme(
      headline1: _defaultTextStyle.copyWith(fontSize: 30, fontWeight: FontWeight.bold),
      headline2: _defaultTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
      headline3: _defaultTextStyle.copyWith(fontSize: 20, fontWeight: FontWeight.w500),
      headline4: _defaultTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w500),

      bodyText2: _defaultTextStyle.copyWith(fontSize: 15),
      /**
       * Used for inputs
       */
      subtitle1: _defaultTextStyle.copyWith(fontSize: 17),
    ),

    /**
     * Elevated buttons are used for action buttons
     */
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        fixedSize: MaterialStateProperty.all<Size>(const Size(56, 56)),
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        shape: MaterialStateProperty.all<OutlinedBorder>(const CircleBorder()),
        backgroundColor: MaterialStateProperty.all<Color>(_colorOrange),
        textStyle: MaterialStateProperty.all<TextStyle>(_defaultTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.white)),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
    ),

    /**
     * Outlined buttons are the primary buttons
     */
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        visualDensity: VisualDensity.compact,
        backgroundColor: MaterialStateProperty.all<Color>(_colorDarkBlue),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(34.0))),
        side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: _colorDarkBlue)),
        fixedSize: MaterialStateProperty.all<Size>(const Size(double.maxFinite, 48)),
        textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
        elevation: MaterialStateProperty.all<double>(4),
        shadowColor: MaterialStateProperty.all<Color>(Colors.black38),
      ),
    ),

    /**
     * Text buttons is only for text
     */
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(_colorDarkBlue),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
    ),

    textSelectionTheme: const TextSelectionThemeData(cursorColor: _colorDarkBlue),

    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      hintStyle: _defaultTextStyle.copyWith(fontSize: 15, color: _colorDarkBlue.withOpacity(0.5)),
      labelStyle: const TextStyle(
        fontStyle: FontStyle.normal,
        color: Color.fromRGBO(20, 55, 95, 0.5),
        fontWeight: FontWeight.w400,
        fontSize: 20,
      ),
      errorStyle: const TextStyle(fontSize: 15, color: _colorError),
      errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _colorError)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _colorDarkBlue)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _colorOrange, width: 2)),
      disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _colorDarkBlue)),
    ),

    tabBarTheme: TabBarTheme(
      labelPadding: const EdgeInsets.symmetric(horizontal: 8),
      labelColor: _colorDarkBlue,
      unselectedLabelColor: const Color(0xFF9EA7B2),
      labelStyle: _defaultTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
      unselectedLabelStyle: _defaultTextStyle.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    ),

    snackBarTheme: SnackBarThemeData(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      backgroundColor: Colors.white,
      contentTextStyle: _defaultTextStyle.copyWith(fontSize: 17, color: _colorDarkBlue, fontWeight: FontWeight.w600),
      elevation: 15,
    ),
  );
}
