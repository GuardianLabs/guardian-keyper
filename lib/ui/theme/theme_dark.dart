part of 'theme.dart';

const systemStyleDark = SystemUiOverlayStyle(
  statusBarColor: Color(0xFF1A0244),
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

final colorSchemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF570FE4),
  primary: const Color(0xFF570FE4),
  onPrimary: clWhite,
  secondary: const Color(0xFF3C089F),
  onSecondary: clWhite,
  tertiary: const Color(0xFFA066F5),
  onTertiary: clWhite,
  error: clRed,
  onError: clYellow,
  background: const Color(0xFF1A0244),
  onBackground: clWhite,
  surface: const Color(0xFF24035F),
  onSurface: const Color(0xFFE6DEF8),
);

final themeDark = ThemeData(
  // Color Scheme
  colorScheme: colorSchemeDark,
  canvasColor: colorSchemeDark.background,
  scaffoldBackgroundColor: colorSchemeDark.background,
  // AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: colorSchemeDark.background,
    centerTitle: true,
    titleTextStyle: stylePoppins616,
    toolbarHeight: 68,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: colorSchemeDark.background,
    selectedItemColor: clGreen,
  ),
  // Bottom Sheet
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: colorSchemeDark.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
    ),
  ),
  // Card
  cardTheme: CardTheme(
    color: colorSchemeDark.surface,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: _shapeBorder,
  ),
  // Divider
  dividerTheme: DividerThemeData(
    color: colorSchemeDark.primary,
    thickness: 2,
  ),
  // Expansion Panel
  expansionTileTheme: ExpansionTileThemeData(
    childrenPadding: paddingAll20,
    collapsedIconColor: clWhite,
    collapsedShape: _shapeBorder,
    iconColor: clWhite,
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
        (states) => states.contains(MaterialState.disabled)
            ? colorSchemeDark.secondary
            : colorSchemeDark.primary,
      ),
    ),
  ),
  // Font family
  fontFamily: GoogleFonts.sourceSans3().fontFamily,
  // Input
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: borderRadius8,
      borderSide: BorderSide(
        color: colorSchemeDark.tertiary,
        width: 2,
      ),
    ),
    floatingLabelStyle: const TextStyle(color: clWhite),
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    tileColor: colorSchemeDark.surface,
    shape: _shapeBorder,
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
              : colorSchemeDark.primary),
    ),
    shape: _buttonShape,
    textStyle: MaterialStateProperty.all<TextStyle>(stylePoppins616),
  )),
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
        states.contains(MaterialState.selected)
            ? colorSchemeDark.tertiary
            : colorSchemeDark.secondary),
    trackOutlineColor:
        MaterialStateProperty.all<Color>(colorSchemeDark.secondary),
    trackOutlineWidth: MaterialStateProperty.all<double>(0),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      color: colorSchemeDark.secondary,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.zero,
    labelColor: clWhite,
    unselectedLabelColor: clWhite,
  ),
  // Text
  textTheme: TextTheme(
    bodySmall: TextStyle(
      color: colorSchemeDark.onSurface,
      fontSize: 10,
      fontWeight: FontWeight.w600,
      overflow: TextOverflow.ellipsis,
    ),
    titleLarge: stylePoppins620,
  ),
  // TextSelection
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: clWhite,
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
