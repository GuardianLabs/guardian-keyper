import 'dart:async';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';
import 'package:guardian_keyper/feature/vault/domain/use_case/vault_interactor.dart';

class OnBecomeOwnerDialog extends StatefulWidget {
  static Future<void> show(
    BuildContext context, {
    required Vault vault,
  }) =>
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => OnBecomeOwnerDialog(vault: vault),
      );

  const OnBecomeOwnerDialog({
    required this.vault,
    super.key, 
  });

  final Vault vault;

  @override
  OnBecomeOwnerDialogState createState() => OnBecomeOwnerDialogState();
}

class OnBecomeOwnerDialogState extends State<OnBecomeOwnerDialog> {
  late final _theme = Theme.of(context);

  late final _brandColors = _theme.extension<BrandColors>();

  late final Timer _timer = Timer.periodic(
    const Duration(seconds: 1),
    (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer.cancel();
      }
    },
  );

  int _countdown = 10;

  @override
  void initState() {
    super.initState();
    _timer.hashCode;
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        icon: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _theme.colorScheme.primary,
          ),
          width: 80,
          height: 80,
          child: Icon(
            Icons.warning,
            color: _brandColors?.warningColor,
            size: 40,
          ),
        ),
        titleString: 'Caution: Irreversible Action!',
        textString: 'By pressing the confirm button, you will cease to be a Guardian '
            'for ${widget.vault.ownerId.name} and will no longer be able to assist with the Safe. '
            '\n\nThe Safe will then be transferred to this device in a dormant state, '
            'meaning its Secrets will remain inaccessible until you obtain sufficient '
            'approvals from the other Guardians of the Safe.'
            '\n\nPlease note, this action is irreversible.',

        footer: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton(
              child: _countdown > 0
                  ? Text('I want to move the Safe ($_countdown)')
                  : const Text('Confirm'),
              style: _theme.filledButtonTheme.style?.copyWith(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (states) => states.contains(MaterialState.disabled)
                          ? _brandColors!.dangerColor.withOpacity(0.5)
                          : _brandColors!.dangerColor,
                    ),
                  ),
              onPressed: _countdown > 0
                  ? null
                  : () async {
                      await GetIt.I<VaultInteractor>()
                          .takeVaultOwnership(widget.vault.id);
                      if (context.mounted) {
                        Navigator.of(context)
                            .popUntil((r) => r.settings.name == '/');
                      }
                    },
            ),
            const Padding(padding: paddingT20),
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
}
