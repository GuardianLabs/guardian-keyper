import 'package:guardian_keyper/ui/utils/guardian_icons.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/styled_icon.dart';

import 'package:guardian_keyper/data/repositories/settings_repository.dart';

class OnSecretSharingDialog extends StatefulWidget {
  static Future<bool?> show(
    BuildContext context, {
    required int maxSize,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => OnSecretSharingDialog(maxSize: maxSize),
      );

  const OnSecretSharingDialog({
    required this.maxSize,
    super.key,
  });

  final int maxSize;

  @override
  State<OnSecretSharingDialog> createState() => _OnSecretSharingDialogState();
}

class _OnSecretSharingDialogState extends State<OnSecretSharingDialog> {
  final _settingsRepository = GetIt.I<SettingsRepository>();

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: StyledIcon(
          icon: GuardianIcons.shard,
          size: 80,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        titleString: 'Understanding Shards',
        textString: 'Your Secret will be divided into ${widget.maxSize} '
            'Shards, each entrusted to a different Guardian. On their own, '
            'these Shards are encrypted and non-functional, providing '
            'enhanced safety. When combined, they allow for the smooth '
            'and on-demand recovery of your Secret.',
        body: CheckboxListTile(
            title: const Text('Do not show again'),
            value: _isChecked,
            onChanged: (value) async {
              await _settingsRepository.setNullable(
                PreferencesKeys.keyIsUnderstandingShardsHidden,
                value,
              );
              setState(() => _isChecked = value ?? false);
            }),
        footer: FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Proceed'),
        ),
      );
}
