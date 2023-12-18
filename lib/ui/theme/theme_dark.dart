part of 'theme.dart';

const systemStyleDark = SystemUiOverlayStyle(
  statusBarColor: clIndigo900,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

final themeDark = ThemeData(
  // Color Scheme
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: clIndigo500,
    primary: clIndigo500,
    onPrimary: clWhite,
    secondary: clIndigo700,
    onSecondary: clWhite,
    tertiary: clIndigo300,
    onTertiary: clWhite,
    error: clRed,
    onError: clYellow,
    background: clIndigo900,
    onBackground: clWhite,
    surface: clSurface,
    onSurface: clWhite,
  ),
  scaffoldBackgroundColor: clIndigo900,
  canvasColor: clIndigo900,
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: clIndigo900,
    centerTitle: true,
    titleTextStyle: stylePoppins616,
    toolbarHeight: 68,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: clIndigo900,
    selectedItemColor: clWhite,
    selectedLabelStyle: styleSourceSansPro612.copyWith(height: 2.5),
    unselectedLabelStyle: styleSourceSansPro412.copyWith(height: 2.5),
  ),
  // Bottom Sheet
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: clIndigo900,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
  ),
  // Card
  cardTheme: CardTheme(
    color: clSurface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: _shapeBorder,
  ),
  // Expansion Panel
  expansionTileTheme: ExpansionTileThemeData(
    childrenPadding: paddingAll20,
    collapsedIconColor: clWhite,
    collapsedShape: _shapeBorder,
    shape: _shapeBorder,
  ),
  // Filled Button
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      fixedSize: _fixedSizeHeight48,
      foregroundColor: _buttonForegroundColor,
      shape: _buttonShape,
      textStyle: MaterialStateProperty.all<TextStyle>(stylePoppins616),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) =>
            states.contains(MaterialState.disabled) ? clIndigo700 : clIndigo500,
      ),
    ),
  ),
  // Icon
  iconTheme: const IconThemeData(color: clWhite),
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: borderRadius8,
      borderSide: const BorderSide(
        color: clIndigo300,
        width: 2,
      ),
    ),
    // focusColor: clIndigo300,

    floatingLabelStyle: const TextStyle(color: clWhite),
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    tileColor: clSurface,
    shape: _shapeBorder,
    titleTextStyle: styleSourceSansPro616,
    subtitleTextStyle: styleSourceSansPro414Purple,
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: _fixedSizeHeight48,
    foregroundColor: _buttonForegroundColor,
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
          color: states.contains(MaterialState.disabled)
              ? const Color(0xFF2E4283)
              : clIndigo500),
    ),
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(stylePoppins616),
  )),
  // Radio
  radioTheme: RadioThemeData(
    fillColor: MaterialStateProperty.all<Color>(clWhite),
  ),
  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: clGreen,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: TextStyle(color: clGreenDark),
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStateProperty.all<Color>(clWhite),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.selected) ? clIndigo300 : clIndigo700),
    trackOutlineColor: MaterialStateProperty.all<Color>(clIndigo700),
    trackOutlineWidth: MaterialStateProperty.all<double>(0),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: const BoxDecoration(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      color: clIndigo700,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.zero,
    labelColor: clWhite,
    labelStyle: styleSourceSansPro614,
    unselectedLabelColor: clWhite,
    unselectedLabelStyle: styleSourceSansPro614,
  ),
  // Text
  textTheme: TextTheme(
    bodySmall: const TextStyle(
      color: clPurpleLight,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    titleLarge: stylePoppins620,
    titleMedium: styleSourceSansPro614,
    bodyMedium: styleSourceSansPro414,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: clWhite,
  ),
  // Text Button
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(clWhite),
    ),
  ),
);

final _fixedSizeHeight48 = MaterialStateProperty.all<Size>(
  const Size(double.infinity, 48),
);

final _shapeBorder = RoundedRectangleBorder(borderRadius: borderRadius8);

final _buttonShape = MaterialStateProperty.all<OutlinedBorder>(
  RoundedRectangleBorder(borderRadius: borderRadius8),
);

final _buttonForegroundColor = MaterialStateProperty.resolveWith<Color>(
  (states) => states.contains(MaterialState.disabled)
      ? const Color(0xFF76678F)
      : clWhite,
);
