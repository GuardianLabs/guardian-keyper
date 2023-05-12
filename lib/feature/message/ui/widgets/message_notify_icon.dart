import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/data/message_repository.dart';

class MessageNotifyIcon extends StatelessWidget {
  final bool isSelected;

  const MessageNotifyIcon({super.key, required this.isSelected});

  @override
  Widget build(final BuildContext context) =>
      ValueListenableBuilder<Box<MessageModel>>(
        valueListenable: GetIt.I<MessageRepository>().listenable(),
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
