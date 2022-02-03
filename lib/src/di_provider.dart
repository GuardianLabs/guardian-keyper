part of 'app.dart';

class DIProvider extends StatelessWidget {
  const DIProvider({
    Key? key,
    required this.settingsController,
  }) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsController),
      ],
      child: const App(),
    );
  }
}
