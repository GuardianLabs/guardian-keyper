part of 'theme.dart';

final colorSchemeLight = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF570FE4),
);

final themeLight = themeData.copyWith(
  // Color Scheme
  colorScheme: colorSchemeLight,
  canvasColor: colorSchemeLight.background,
  scaffoldBackgroundColor: colorSchemeLight.background,
);
