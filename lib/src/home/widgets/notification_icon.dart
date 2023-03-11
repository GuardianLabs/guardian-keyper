import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

class MessagesIcon extends StatelessWidget {
  final bool isSelected;

  const MessagesIcon({super.key, this.isSelected = false});

  const MessagesIcon.selected({super.key}) : isSelected = true;

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable: context.read<DIContainer>().boxMessages.listenable(),
        builder: (_, boxMessages, __) {
          final count = boxMessages.values.where((e) => e.isReceived).length;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              isSelected
                  ? const IconOf.navBarBellSelected()
                  : const IconOf.navBarBell(),
              if (count > 0)
                Positioned(
                  top: -3,
                  right: -3,
                  child: DotColored(
                    color: clRed,
                    size: 17,
                    child: Center(
                      child: Text(
                        count > 9 ? '$count+' : count.toString(),
                        style: textStyleSourceSansPro612.copyWith(
                          color: clIndigo900,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
}
