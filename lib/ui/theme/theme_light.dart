part of 'theme.dart';

const systemStyleLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

const colorSwatchLight = MaterialColor(
  0xFF5A37E6,
  {
    50: Color(0xFFF0EDFD),
    100: Color(0xFFD2C8F8),
    200: Color(0xFFB4A4F4),
    300: Color(0xFF9680EF),
    400: Color(0xFF785BEB),
    500: Color(0xFF5A37E6),
    600: Color(0xFF411BDA),
    700: Color(0xFF3616B6),
    800: Color(0xFF2B1291),
    900: Color(0xFF210D6D),
  },
);

final colorSchemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: colorSwatchLight.shade500,
).copyWith(
  background: const Color(0xFFF7F7F7),
  onBackground: const Color(0xFF6A6581),
  primary: colorSwatchLight.shade500,
  onPrimary: Colors.white,
  primaryContainer: colorSwatchLight.shade400,
  onPrimaryContainer: Colors.white,
  secondary: const Color(0xFF625B71),
  onSecondary: Colors.white,
  secondaryContainer: const Color(0xFFE5DFF9),
  onSecondaryContainer: const Color(0xFF1C192B),
  tertiary: const Color(0xFFE9E8ED),
  onTertiary: const Color(0xFF120D23),
  tertiaryContainer: const Color(0xFFE9E8ED),
  onTertiaryContainer: const Color(0xFF120D23),
  surface: Colors.white,
  surfaceTint: const Color(0xFFF7F7F7),
  onSurface: const Color(0xFF120D23),
  onSurfaceVariant: const Color(0xFF6A6581),
  error: const Color(0xFFE63737),
  onError: Colors.white,
  errorContainer: const Color(0xFFF6EAEA),
  onErrorContainer: const Color(0xFFD32C2C),
);

const colorSchemeExtensionLight = BrandColors(
  highlightColor: Color(0xFF62D6CB),
  warningColor: Color(0xFFF19C38),
  dangerColor: Color(0xFFEC5F59),
);

final themeLight = themeData.copyWith(
  // Color Scheme
  colorScheme: colorSchemeLight,
  canvasColor: colorSchemeLight.background,
  scaffoldBackgroundColor: colorSchemeLight.background,
  extensions: [colorSchemeExtensionLight],
  // AppBar
  appBarTheme: themeData.appBarTheme.copyWith(
    backgroundColor: colorSchemeLight.background,
    surfaceTintColor: colorSchemeLight.background,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: themeData.bottomNavigationBarTheme.copyWith(
    backgroundColor: colorSchemeLight.background,
    selectedItemColor: colorSchemeLight.primary,
    unselectedItemColor: colorSchemeLight.onBackground,
  ),
  // Bottom Sheet
  bottomSheetTheme: themeData.bottomSheetTheme.copyWith(
    backgroundColor: colorSchemeLight.background,
  ),
  // Card
  // cardTheme: themeData.cardTheme.copyWith(
  //   color: colorSchemeLight.surface,
  // ),
  // Divider
  // dividerTheme: themeData.dividerTheme.copyWith(
  //   color: colorSchemeLight.primary,
  // ),
  // Expansion Panel
  // expansionTileTheme: themeData.expansionTileTheme.copyWith(
  //   collapsedIconColor: colorSchemeLight.onPrimary,
  //   iconColor: colorSchemeLight.onPrimary,
  // ),
  // Icon
  // iconTheme: IconThemeData(
  //   color: colorSchemeLight.onPrimary,
  // ),
  // ListTile
  listTileTheme: themeData.listTileTheme.copyWith(
    tileColor: colorSchemeLight.surface,
    iconColor: colorSchemeLight.onSurface,
  ),
  // SnackBar
  snackBarTheme: themeData.snackBarTheme.copyWith(
    backgroundColor: colorSchemeExtensionDark.highlightColor,
    contentTextStyle: const TextStyle(color: Color(0xFF004D45)),
  ),
  // Switch
  switchTheme: SwitchThemeData(
    thumbColor: MaterialStatePropertyAll(colorSchemeLight.onPrimary),
    trackColor: MaterialStateProperty.resolveWith<Color>((states) =>
        states.contains(MaterialState.selected)
            ? colorSchemeLight.tertiary
            : colorSchemeLight.secondary),
    trackOutlineColor: MaterialStatePropertyAll(colorSchemeLight.secondary),
    trackOutlineWidth: const MaterialStatePropertyAll(0),
  ),
  // TabBar
  tabBarTheme: themeData.tabBarTheme.copyWith(
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(10),
      ),
      color: colorSchemeLight.secondary,
    ),
    labelPadding: EdgeInsets.zero,
    labelColor: colorSchemeLight.onPrimary,
    unselectedLabelColor: colorSchemeLight.onSecondary,
  ),
);
