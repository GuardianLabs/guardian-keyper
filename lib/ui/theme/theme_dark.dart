part of 'theme.dart';

const systemStyleDark = SystemUiOverlayStyle(
  statusBarColor: clIndigo900,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

final themeDark = ThemeData.dark().copyWith(
  // ignore: deprecated_member_use
  useMaterial3: false,
  // Color Scheme
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: clWhite,
    onPrimary: clIndigo600,
    secondary: clIndigo700,
    onSecondary: clWhite,
    error: clRed,
    onError: clYellow,
    background: clIndigo900,
    onBackground: clBlue,
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
    shape: RoundedRectangleBorder(borderRadius: borderRadiusTop10),
  ),
  // Card
  cardTheme: CardTheme(
    color: clSurface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: _shapeBorder,
  ),
  // Expansion Panel
  expansionTileTheme: const ExpansionTileThemeData(
    backgroundColor: clSurface,
    childrenPadding: paddingAll20,
    collapsedIconColor: clWhite,
    iconColor: clWhite,
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
            states.contains(MaterialState.disabled) ? clIndigo800 : clIndigo500,
      ),
    ),
  ),
  // Icon
  iconTheme: const IconThemeData(color: clWhite),
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        var borderWidth = 1.0;
        var borderColor = const Color(0x55E9F8FE);
        if (states.contains(MaterialState.focused)) {
          borderWidth = 2;
          borderColor = clBlue;
        }
        if (states.contains(MaterialState.error)) {
          borderColor = clRed;
        }
        return OutlineInputBorder(
          borderRadius: borderRadius8,
          borderSide: BorderSide(width: borderWidth, color: borderColor),
        );
      },
    ),
    counterStyle: styleSourceSansPro412,
    helperStyle: styleSourceSansPro412,
    labelStyle: styleSourceSansPro412,
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    iconColor: clWhite,
    tileColor: clSurface,
    textColor: clWhite,
    shape: _shapeBorder,
    titleTextStyle: styleSourceSansPro616,
    subtitleTextStyle: styleSourceSansPro414,
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
        states.contains(MaterialState.selected) ? clBlue : clIndigo700),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: const BoxDecoration(
      borderRadius: borderRadiusTop10,
      color: clIndigo600,
    ),
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
  // Text Button
  textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(clWhite),
  )),
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
