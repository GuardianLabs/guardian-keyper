import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

class GroupSizeInfoPanel extends StatefulWidget {
  final int atLeast, ofAmount;

  const GroupSizeInfoPanel({
    super.key,
    required this.atLeast,
    required this.ofAmount,
  });

  @override
  State<GroupSizeInfoPanel> createState() => _GroupSizeInfoPanelState();
}

class _GroupSizeInfoPanelState extends State<GroupSizeInfoPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..forward();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InfoPanel.info(
        animationController: _animationController,
        textSpan: <TextSpan>[
          const TextSpan(
            text: 'Recovering Secrets from this Vault '
                'will require approval of at least ',
          ),
          TextSpan(
            text: '${widget.ofAmount} out of ${widget.atLeast}',
            style: textStyleSourceSansPro616.copyWith(color: clWhite),
          ),
          const TextSpan(text: ' Guardians'),
        ],
      );
}
