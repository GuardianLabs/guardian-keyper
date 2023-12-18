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

final colorSchemeLight = ColorScheme.fromSwatch(
  brightness: Brightness.light,
  primarySwatch: colorSwatchLight,
).copyWith(
  primary: colorSwatchLight.shade500,
  onPrimary: Colors.white,
  primaryContainer: colorSwatchLight.shade400,
  onPrimaryContainer: Colors.white,
  surface: Colors.white,
  surfaceTint: const Color(0xFFF7F7F7),
  onSurface: const Color(0xFF120D23),
  onSurfaceVariant: colorSwatchLight.shade500,
  background: const Color(0xFFF7F7F7),
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
);
