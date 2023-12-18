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
  onPrimary: Colors.white,
  secondary: const Color(0xFF3C089F),
  onSecondary: const Color(0xFFE6DEF8),
  tertiary: const Color(0xFFA066F5),
  onTertiary: Colors.white,
  error: clRed,
  onError: clYellow,
  background: const Color(0xFF1A0244),
  onBackground: Colors.white,
  surface: const Color(0xFF24035F),
  onSurface: const Color(0xFFE6DEF8),
);

final textThemeDark = TextTheme(
  bodyMedium: TextStyle(
    color: colorSchemeDark.onSurface,
    // fontSize: 16,
    // fontWeight: FontWeight.w400,
  ),
  bodySmall: TextStyle(
    color: colorSchemeDark.onSurface,
    // fontSize: 10,
    // fontWeight: FontWeight.w400,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
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
    titleTextStyle: textThemeDark.titleMedium,
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Divider
  dividerTheme: DividerThemeData(
    color: colorSchemeDark.primary,
    thickness: 2,
  ),
  // Expansion Panel
  expansionTileTheme: ExpansionTileThemeData(
    childrenPadding: paddingAll20,
    collapsedIconColor: colorSchemeDark.onPrimary,
    collapsedShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    iconColor: colorSchemeDark.onPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Filled Button
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 48)),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => states.contains(MaterialState.disabled)
            ? const Color(0xFF76678F)
            : colorSchemeDark.onPrimary,
      ),
      shape: MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textStyle: MaterialStatePropertyAll(textThemeDark.titleMedium),
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
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorSchemeDark.tertiary,
        width: 2,
      ),
    ),
    floatingLabelStyle: TextStyle(color: colorSchemeDark.onPrimary),
  ),
  // ListTile
  listTileTheme: ListTileThemeData(
    tileColor: colorSchemeDark.surface,
    titleTextStyle: styleSourceSansPro614,
    subtitleTextStyle: styleSourceSansPro414.copyWith(
      color: colorSchemeDark.onSecondary,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
    fixedSize: const MaterialStatePropertyAll(Size(double.infinity, 48)),
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) => states.contains(MaterialState.disabled)
          ? const Color(0xFF76678F)
          : colorSchemeDark.onPrimary,
    ),
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
          color: states.contains(MaterialState.disabled)
              ? const Color(0xFF2E4283)
              : colorSchemeDark.primary),
    ),
    shape: MaterialStatePropertyAll(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    textStyle: MaterialStatePropertyAll(textThemeDark.titleMedium),
  )),
  // SnackBar
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: clGreen,
    behavior: SnackBarBehavior.floating,
    contentTextStyle: TextStyle(color: clGreenDark),
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStatePropertyAll(colorSchemeDark.onPrimary),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.selected)
            ? colorSchemeDark.tertiary
            : colorSchemeDark.secondary),
    trackOutlineColor: MaterialStatePropertyAll(colorSchemeDark.secondary),
    trackOutlineWidth: const MaterialStatePropertyAll(0),
  ),
  // TabBar
  tabBarTheme: TabBarTheme(
    indicator: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10),
      ),
      color: colorSchemeDark.secondary,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    labelPadding: EdgeInsets.zero,
    labelColor: colorSchemeDark.onPrimary,
    unselectedLabelColor: colorSchemeDark.onSecondary,
  ),
  // Text
  textTheme: textThemeDark,
  // TextSelection
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: colorSchemeDark.onPrimary,
  ),
);
