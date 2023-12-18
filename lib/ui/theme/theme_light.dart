part of 'theme.dart';

const systemStyleLight = SystemUiOverlayStyle(
  // statusBarColor: Color(0xFF1A0244),
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
);

final colorSchemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF570FE4),
  // primary: const Color(0xFF570FE4),
  // onPrimary: Colors.white,
  // secondary: const Color(0xFF3C089F),
  // onSecondary: const Color(0xFFE6DEF8),
  // tertiary: const Color(0xFFA066F5),
  // onTertiary: Colors.white,
  // error: clRed,
  // onError: const Color(0xFFF19C38),
  // background: const Color(0xFF1A0244),
  // onBackground: Colors.white,
  // surface: const Color(0xFF24035F),
  // onSurface: const Color(0xFFE6DEF8),
);

final themeLight = themeData.copyWith(
  // Color Scheme
  colorScheme: colorSchemeLight,
  canvasColor: colorSchemeLight.background,
  scaffoldBackgroundColor: colorSchemeLight.background,

  // TextSelection
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: colorSchemeLight.onPrimary,
  ),
);
