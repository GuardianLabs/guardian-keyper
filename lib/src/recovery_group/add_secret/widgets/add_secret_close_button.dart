import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

class AddSecretCloseButton extends StatelessWidget {
  const AddSecretCloseButton({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showModalBottomSheet<bool>(
          context: context,
          isScrollControlled: true,
          builder: (context) => BottomSheetWidget(
            icon: const IconOf.splitAndShare(isBig: true, bage: BageType.error),
            titleString: 'Cancel adding a Secret?',
            textString: 'All progress will be lost, you’ll have to start '
                'from the beginning. Are you sure?',
            footer: Padding(
              padding: paddingV20,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('No'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: PrimaryButton(
                      text: 'Yes',
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).then((result) => result == true ? Navigator.of(context).pop() : null),
        child: Center(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).listTileTheme.tileColor,
            child: const Icon(Icons.close, color: clWhite),
          ),
        ),
      );
}
