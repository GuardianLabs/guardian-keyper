import '/src/core/ui/widgets/common.dart';

import '../vault_create_presenter.dart';

class GuardianCountRadio extends StatelessWidget {
  static final _boxDecorationSelected = BoxDecoration(
    border: Border.all(color: clIndigo500),
    borderRadius: borderRadius,
    gradient: const RadialGradient(
      center: Alignment.bottomCenter,
      radius: 1.4,
      colors: [Color(0xFF7E4CDE), Color(0xFF35088B)],
    ),
  );

  final bool isChecked;
  final int groupSize, groupThreshold;

  const GuardianCountRadio({
    super.key,
    required this.isChecked,
    required this.groupSize,
    required this.groupThreshold,
  });

  @override
  Widget build(final BuildContext context) => InkWell(
        onTap: () {
          final controller = context.read<VaultCreatePresenter>();
          controller.groupSize = groupSize;
          controller.groupThreshold = groupThreshold;
        },
        child: Container(
          decoration: isChecked ? _boxDecorationSelected : null,
          padding: paddingV12,
          child: Column(
            children: [
              Text('$groupSize Guardians'),
              const SizedBox(height: 12),
              Icon(isChecked ? Icons.radio_button_on : Icons.radio_button_off),
            ],
          ),
        ),
      );
}
