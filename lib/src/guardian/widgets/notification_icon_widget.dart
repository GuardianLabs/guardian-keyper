import '/src/core/theme_data.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/icon_of.dart';

import '../guardian_controller.dart';

class NotificationIconWidget extends StatelessWidget {
  final bool isSelected;

  const NotificationIconWidget({super.key, this.isSelected = false});

  const NotificationIconWidget.selected({super.key}) : isSelected = true;

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    final count = controller.messagesProcessed.length;
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
                style: textStyleSourceSansPro612.copyWith(color: clIndigo900),
              )),
            ),
          ),
      ],
    );
  }
}
