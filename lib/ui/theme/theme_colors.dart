part of 'theme.dart';

const colorSwatchIndigo = MaterialColor(
  0xFF5A37E6,
  {
    50: Color(0xFFEFE6FD),
    100: Color(0xFFDFCCFC),
    200: Color(0xFFBF99F8),
    300: Color(0xFFA066F5),
    400: Color(0xFF8033F1),
    500: Color(0xFF6000EE),
    600: Color(0xFF5600D6),
    700: Color(0xFF4300A7),
    800: Color(0xFF300077),
    900: Color(0xFF1D0047),
  },
);

const brandColors = BrandColors(
  highlightColor: Color(0xFF62D6CB),
  warningColor: Color(0xFFFF9800),
  dangerColor: Color(0xFFEC5F59),
);

const systemStyleLight = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

const systemStyleDark = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
);

final colorSchemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: colorSwatchIndigo.shade600,
  primary: colorSwatchIndigo.shade600,
  onPrimary: colorSwatchIndigo.shade50,
  secondary: colorSwatchIndigo.shade500,
  onSecondary: colorSwatchIndigo.shade800,
  secondaryContainer: colorSwatchIndigo.shade100,
  onSecondaryContainer: colorSwatchIndigo.shade700,
  tertiary: colorSwatchIndigo.shade500,
  error: brandColors.dangerColor,
  onError: brandColors.warningColor,
  surface: colorSwatchIndigo.shade50,
  surfaceTint: Colors.white,
  onSurface: colorSwatchIndigo.shade800,
  //Not used yet
  // primaryContainer: colorGuardianIndigo.shade600,
  // onPrimaryContainer: colorGuardianIndigo.shade50,
  // onTertiary: colorGuardianIndigo.shade50,
  // onSurfaceVariant: colorGuardianIndigo.shade800,
  // errorContainer: const Color(0x22F6EAEA),
  // onErrorContainer: const Color(0xFFD32C2C),
);

final colorSchemeDark = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: colorSwatchIndigo.shade600,
  primary: colorSwatchIndigo.shade600,
  onPrimary: colorSwatchIndigo.shade50,
  secondary: colorSwatchIndigo.shade700,
  onSecondary: colorSwatchIndigo.shade50,
  secondaryContainer: colorSwatchIndigo.shade700,
  onSecondaryContainer: colorSwatchIndigo.shade100,
  tertiary: colorSwatchIndigo.shade500,
  onTertiary: colorSwatchIndigo.shade50,
  error: brandColors.dangerColor,
  onError: brandColors.warningColor,
  surface: colorSwatchIndigo.shade800,
  surfaceTint: colorSwatchIndigo.shade900,
  onSurface: colorSwatchIndigo.shade50,
  //Not used yet
  // primaryContainer: colorGuardianIndigo.shade600,
  // onPrimaryContainer: colorGuardianIndigo.shade50,
  // errorContainer: const Color(0x22F6EAEA),
  // onErrorContainer: const Color(0xFFD32C2C),
  // onSurfaceVariant: colorGuardianIndigo.shade50,
);

final lightTheme = _createAppTheme(Brightness.light);
final darkTheme = _createAppTheme(Brightness.dark);

ThemeData _createAppTheme(Brightness brightness) {
  final isDarkMode = brightness == Brightness.dark;
  final colorScheme = isDarkMode ? colorSchemeDark : colorSchemeLight;

  return themeData.copyWith(
    brightness: brightness,
    colorScheme: colorScheme,
    canvasColor: colorScheme.surfaceTint,
    scaffoldBackgroundColor: colorScheme.surfaceTint,
    extensions: [brandColors],
    unselectedWidgetColor: colorScheme.onSurface,
    // AppBar
    appBarTheme: themeData.appBarTheme.copyWith(
        backgroundColor: colorScheme.surfaceTint,
        surfaceTintColor: colorScheme.surfaceTint,
        systemOverlayStyle: isDarkMode ? systemStyleDark : systemStyleLight,
        titleTextStyle: textTheme.titleLarge!.copyWith(
          color: colorScheme.onSurface,
        ),
        toolbarHeight: kToolbarHeight + 32,
        iconTheme: IconThemeData(color: colorScheme.onSurface)),
    // Card
    cardTheme: themeData.cardTheme.copyWith(
      color: colorScheme.surface,
    ),
    // Check Box
    checkboxTheme: CheckboxThemeData(
      side: BorderSide(color: colorScheme.onSurface),
      checkColor: WidgetStatePropertyAll(colorScheme.onSurface),
    ),
    // Divider
    dividerTheme: themeData.dividerTheme.copyWith(
      color: colorScheme.tertiary,
    ),
    // Expansion Panel
    expansionTileTheme: themeData.expansionTileTheme.copyWith(
      collapsedIconColor: colorScheme.onSurface,
      iconColor: colorScheme.onSurface,
      textColor: colorScheme.onSurface,
    ),
    // Filled Button
    filledButtonTheme: FilledButtonThemeData(
      style: themeData.filledButtonTheme.style!.copyWith(
        foregroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? colorScheme.onPrimary.withOpacity(0.5)
              : colorScheme.onPrimary,
        ),
        backgroundColor: WidgetStateProperty.resolveWith<Color>(
          (states) => states.contains(WidgetState.disabled)
              ? colorScheme.primary.withOpacity(0.5)
              : colorScheme.primary,
        ),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
          ),
        ),
      ),
    ),
    // Icon
    iconTheme: IconThemeData(
      color: colorScheme.onPrimary,
    ),
    // Input
    inputDecorationTheme: themeData.inputDecorationTheme.copyWith(
      border: themeData.inputDecorationTheme.border?.copyWith(
        borderSide: themeData.inputDecorationTheme.border!.borderSide.copyWith(
          color: colorScheme.tertiary,
        ),
      ),
      floatingLabelStyle:
          themeData.inputDecorationTheme.floatingLabelStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
      labelStyle: themeData.inputDecorationTheme.labelStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
      helperStyle: themeData.inputDecorationTheme.helperStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
    ),
    // ListTile
    listTileTheme: themeData.listTileTheme.copyWith(
      tileColor: colorScheme.surface,
      titleTextStyle: themeData.listTileTheme.titleTextStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: themeData.listTileTheme.subtitleTextStyle?.copyWith(
        color: colorScheme.onSurface,
      ),
      iconColor: colorScheme.onSurface,
    ),
    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: themeData.filledButtonTheme.style?.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith<Color>(
        (states) => states.contains(WidgetState.disabled)
            ? colorScheme.onSurface.withOpacity(0.5)
            : colorScheme.onSurface,
      ),
      shape: const WidgetStatePropertyAll<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.all(Radius.circular(8)),
        ),
      ),
      side: WidgetStateProperty.resolveWith<BorderSide>(
        (states) => BorderSide(
          color: states.contains(WidgetState.disabled)
              ? colorScheme.primary.withOpacity(0.5)
              : colorScheme.primary,
        ),
      ),
    )),
    // SnackBar
    snackBarTheme: themeData.snackBarTheme.copyWith(
      backgroundColor: brandColors.highlightColor,
      contentTextStyle: const TextStyle(color: Color(0xFF004D45)),
      closeIconColor: const Color(0xFF004D45),
      showCloseIcon: true,
    ),
    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStatePropertyAll(colorScheme.onPrimary),
      trackColor: WidgetStateProperty.resolveWith<Color>((states) =>
          states.contains(WidgetState.selected)
              ? colorScheme.tertiary
              : colorScheme.secondary),
      trackOutlineColor: WidgetStatePropertyAll(colorScheme.secondary),
      trackOutlineWidth: const WidgetStatePropertyAll(0),
    ),

    // TextSelection
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: colorScheme.onPrimary,
    ),

    //Text
    textTheme: textTheme.copyWith(
      bodyLarge: textTheme.bodyLarge!.copyWith(
        color: colorScheme.onSurface,
      ),
      bodyMedium: textTheme.bodyMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      bodySmall: textTheme.bodySmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      labelLarge: textTheme.labelLarge!.copyWith(
        color: colorScheme.onSurface,
      ),
      labelMedium: textTheme.labelMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      labelSmall: textTheme.labelSmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      titleLarge: textTheme.titleLarge!.copyWith(
        color: colorScheme.onSurface,
      ),
      titleMedium: textTheme.titleMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      titleSmall: textTheme.titleSmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineLarge: textTheme.headlineLarge!.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineMedium: textTheme.headlineMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      headlineSmall: textTheme.headlineSmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      displaySmall: textTheme.displaySmall!.copyWith(
        color: colorScheme.onSurface,
      ),
      displayMedium: textTheme.displayMedium!.copyWith(
        color: colorScheme.onSurface,
      ),
      displayLarge: textTheme.displayLarge!.copyWith(
        color: colorScheme.onSurface,
      ),
    ),

    // ignore: deprecated_member_use
    useMaterial3: false,
  );
}
