import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../domain/use_case/message_interactor.dart';

class MessageNotifyIcon extends StatelessWidget {
  const MessageNotifyIcon({super.key, required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final messageInteractor = GetIt.I<MessageInteractor>();
    return StreamBuilder(
      stream: messageInteractor.watch(),
      builder: (_, __) {
        final count =
            messageInteractor.messages.where((e) => e.isReceived).length;
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
                      style: styleSourceSansPro612.copyWith(
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
}
