sealed class SettingsRepositoryEvent {
  const SettingsRepositoryEvent();
}

final class SettingsRepositoryEventThemeMode extends SettingsRepositoryEvent {
  const SettingsRepositoryEventThemeMode({
    this.isDarkModeOn,
  });

  final bool? isDarkModeOn;
}
