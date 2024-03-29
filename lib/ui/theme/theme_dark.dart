part of 'theme.dart';

const systemStyleDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

const colorSchemeExtensionDark = BrandColors(
  highlightColor: Color(0xFF62D6CB),
  warningColor: Color(0xFFF19C38),
  dangerColor: Color(0xFFEC5F59),
);

final colorSchemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color(0xFF570FE4),
  primary: const Color(0xFF570FE4),
  onPrimary: Colors.white,
  secondary: const Color(0xFF3C089F),
  primaryContainer: const Color(0xFF570FE4),
  onPrimaryContainer: Colors.white,
  onSecondary: const Color(0xFFE6DEF8),
  secondaryContainer: const Color(0xFF3C089F),
  onSecondaryContainer: const Color(0xFFE6DEF8),
  tertiary: const Color(0xFFA066F5),
  onTertiary: Colors.white,
  error: const Color(0xFFEC5F59),
  onError: const Color(0xFFF19C38),
  errorContainer: const Color(0x22F6EAEA),
  onErrorContainer: const Color(0xFFD32C2C),
  background: const Color(0xFF1A0244),
  onBackground: Colors.white,
  surface: const Color(0xFF24035F),
  onSurface: const Color(0xFFE6DEF8),
  onSurfaceVariant: const Color(0xFFE6DEF8),
);

final themeDark = themeData.copyWith(
  // Color Scheme
  colorScheme: colorSchemeDark,
  canvasColor: colorSchemeDark.background,
  scaffoldBackgroundColor: colorSchemeDark.background,
  extensions: [colorSchemeExtensionDark],
  unselectedWidgetColor: colorSchemeDark.onSurface,
  // AppBar
  appBarTheme: themeData.appBarTheme.copyWith(
    backgroundColor: colorSchemeDark.background,
    surfaceTintColor: colorSchemeDark.background,
    systemOverlayStyle: systemStyleDark,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: themeData.bottomNavigationBarTheme.copyWith(
    backgroundColor: colorSchemeDark.background,
    selectedItemColor: colorSchemeExtensionDark.highlightColor,
    unselectedItemColor: colorSchemeDark.onBackground,
  ),
  // Bottom Sheet
  bottomSheetTheme: themeData.bottomSheetTheme.copyWith(
    backgroundColor: colorSchemeDark.background,
  ),
  // Card
  cardTheme: themeData.cardTheme.copyWith(
    color: colorSchemeDark.surface,
  ),
  // Check Box
  checkboxTheme: CheckboxThemeData(
    side: BorderSide(color: colorSchemeDark.onSurface),
    checkColor: MaterialStatePropertyAll(colorSchemeDark.onSurface),
  ),
  // Divider
  dividerTheme: themeData.dividerTheme.copyWith(
    color: colorSchemeDark.primary,
  ),
  // Expansion Panel
  expansionTileTheme: themeData.expansionTileTheme.copyWith(
    collapsedIconColor: colorSchemeDark.onPrimary,
    iconColor: colorSchemeDark.onPrimary,
    textColor: colorSchemeDark.onPrimary,
  ),
  // Filled Button
  filledButtonTheme: FilledButtonThemeData(
    style: themeData.filledButtonTheme.style!.copyWith(
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => states.contains(MaterialState.disabled)
            ? colorSchemeDark.onPrimary.withOpacity(0.5)
            : colorSchemeDark.onPrimary,
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (states) => states.contains(MaterialState.disabled)
            ? colorSchemeDark.primary.withOpacity(0.5)
            : colorSchemeDark.primary,
      ),
      shape: const MaterialStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
        ),
      ),
    ),
  ),
  // Icon
  iconTheme: IconThemeData(
    color: colorSchemeDark.onPrimary,
  ),
  // Input
  inputDecorationTheme: themeData.inputDecorationTheme.copyWith(
    border: themeData.inputDecorationTheme.border?.copyWith(
      borderSide: themeData.inputDecorationTheme.border!.borderSide.copyWith(
        color: colorSchemeDark.secondary,
      ),
    ),
    floatingLabelStyle:
        themeData.inputDecorationTheme.floatingLabelStyle?.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    labelStyle: themeData.inputDecorationTheme.labelStyle?.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    helperStyle: themeData.inputDecorationTheme.helperStyle?.copyWith(
      color: colorSchemeDark.onSurface,
    ),
  ),
  // ListTile
  listTileTheme: themeData.listTileTheme.copyWith(
    tileColor: colorSchemeDark.surface,
    titleTextStyle: themeData.listTileTheme.titleTextStyle?.copyWith(
      color: colorSchemeDark.onPrimary,
    ),
    subtitleTextStyle: themeData.listTileTheme.subtitleTextStyle?.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    iconColor: colorSchemeDark.onSurface,
  ),
  // Outlined Button
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: themeData.filledButtonTheme.style?.copyWith(
    foregroundColor: MaterialStateProperty.resolveWith<Color>(
      (states) => states.contains(MaterialState.disabled)
          ? colorSchemeDark.onPrimary.withOpacity(0.5)
          : colorSchemeDark.onPrimary,
    ),
    shape: const MaterialStatePropertyAll<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
      ),
    ),
    side: MaterialStateProperty.resolveWith<BorderSide>(
      (states) => BorderSide(
        color: states.contains(MaterialState.disabled)
            ? colorSchemeDark.primary.withOpacity(0.5)
            : colorSchemeDark.primary,
      ),
    ),
  )),
  // SnackBar
  snackBarTheme: themeData.snackBarTheme.copyWith(
    backgroundColor: colorSchemeExtensionDark.highlightColor,
    contentTextStyle: const TextStyle(color: Color(0xFF004D45)),
    closeIconColor: const Color(0xFF004D45),
    showCloseIcon: true,
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
  tabBarTheme: themeData.tabBarTheme.copyWith(
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10),
      ),
      color: colorSchemeDark.secondary,
    ),
    labelPadding: EdgeInsets.zero,
    labelColor: colorSchemeDark.onPrimary,
    unselectedLabelColor: colorSchemeDark.onSecondary,
  ),
  // TextSelection
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: colorSchemeDark.onPrimary,
  ),
  textTheme: textTheme.copyWith(
    bodyLarge: textTheme.bodyLarge!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    bodyMedium: textTheme.bodyMedium!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    bodySmall: textTheme.bodySmall!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    labelLarge: textTheme.labelLarge!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    labelMedium: textTheme.labelMedium!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
    labelSmall: textTheme.labelSmall!.copyWith(
      color: colorSchemeDark.onSurface,
    ),
  ),
  // ignore: deprecated_member_use
  useMaterial3: false,
);
