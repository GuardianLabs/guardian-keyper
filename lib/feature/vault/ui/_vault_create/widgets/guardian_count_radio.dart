import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class GuardianCountRadio extends StatelessWidget {
  static final _boxDecorationSelected = BoxDecoration(
    border: Border.all(color: clIndigo500),
    borderRadius: borderRadius8,
    gradient: const RadialGradient(
      center: Alignment.bottomCenter,
      radius: 1.4,
      colors: [Color(0xFF7E4CDE), Color(0xFF35088B)],
    ),
  );

  final bool isChecked;
  final int vaultSize, vaultThreshold;

  const GuardianCountRadio({
    super.key,
    required this.isChecked,
    required this.vaultSize,
    required this.vaultThreshold,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context
            .read<VaultCreatePresenter>()
            .setVaultSize(vaultSize, vaultThreshold),
        child: Container(
          decoration: isChecked ? _boxDecorationSelected : null,
          padding: paddingV12,
          child: Column(
            children: [
              Text('$vaultSize Guardians'),
              const SizedBox(height: 12),
              Icon(isChecked ? Icons.radio_button_on : Icons.radio_button_off),
            ],
          ),
        ),
      );
}
