import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class VaultSizeInfoPanel extends StatefulWidget {
  const VaultSizeInfoPanel({super.key});

  @override
  State<VaultSizeInfoPanel> createState() => _VaultSizeInfoPanelState();
}

class _VaultSizeInfoPanelState extends State<VaultSizeInfoPanel>
    with SingleTickerProviderStateMixin {
  late final _animationController = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<VaultCreatePresenter>(context);
    _animationController.forward(from: 0);
    return InfoPanel.info(
      animationController: _animationController,
      textSpan: <TextSpan>[
        const TextSpan(
          text: 'Recovering Secrets from this Vault '
              'will require approval of at least ',
        ),
        TextSpan(
          text: '${presenter.ofAmount} out of ${presenter.atLeast}',
          style: textStyleSourceSansPro616.copyWith(color: clWhite),
        ),
        const TextSpan(text: ' Guardians'),
      ],
    );
  }
}
