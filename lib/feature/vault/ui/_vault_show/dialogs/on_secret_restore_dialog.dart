import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/data/repositories/settings_repository.dart';

class OnSecretRestoreDialog extends StatefulWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const OnSecretRestoreDialog(),
      );

  const OnSecretRestoreDialog({super.key});

  @override
  State<OnSecretRestoreDialog> createState() => _OnSecretRestoreDialogState();
}

class _OnSecretRestoreDialogState extends State<OnSecretRestoreDialog> {
  final _settingsRepository = GetIt.I<SettingsRepository>();

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: 'Keep the app open!',
        textString: 'Do not exit or minimize the app during the recovery, '
            'as you are connected via peer-to-peer (P2P), '
            'and doing so could disrupt the process.',
        body: CheckboxListTile(
            title: const Text('Do not show again'),
            value: _isChecked,
            onChanged: (value) async {
              await _settingsRepository.putNullable(
                SettingsRepositoryKeys.keyIsSecretRestoreExplainerHidden,
                value,
              );
              setState(() => _isChecked = value ?? false);
            }),
        footer: FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Got it'),
        ),
      );
}
