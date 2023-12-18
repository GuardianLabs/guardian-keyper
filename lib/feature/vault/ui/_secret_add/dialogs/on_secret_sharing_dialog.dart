import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/vault/ui/_secret_add/vault_secret_add_presenter.dart';

class OnSecretSharingDialog extends StatefulWidget {
  static Future<bool?> show(BuildContext context) => showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        builder: (_) => OnSecretSharingDialog(
          presenter: context.read<VaultSecretAddPresenter>(),
        ),
      );

  const OnSecretSharingDialog({
    required this.presenter,
    super.key,
  });

  final VaultSecretAddPresenter presenter;

  @override
  State<OnSecretSharingDialog> createState() => _OnSecretSharingDialogState();
}

class _OnSecretSharingDialogState extends State<OnSecretSharingDialog> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: const IconOf.shard(size: 80),
        titleString: 'Understanding Shards',
        textString:
            'Your Secret will be split into ${widget.presenter.vault.maxSize} '
            'Shards, with each Guardian receiving one. Individually, '
            'Shards are encrypted and non-functional, ensuring safety. '
            'Together, they enable seamless, '
            'on-demand recovery of your Secret.',
        body: CheckboxListTile(
            title: const Text('Don not show again'),
            value: _isChecked,
            onChanged: (value) async {
              await widget.presenter.setIsUnderstandingShardsHidden(value);
              setState(() => _isChecked = value ?? false);
            }),
        footer: FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Proceed'),
        ),
      );
}
