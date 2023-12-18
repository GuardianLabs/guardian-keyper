import 'package:get_it/get_it.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class NotificationsIcon extends StatelessWidget {
  const NotificationsIcon({
    required this.isSelected,
    required this.iconSize,
    super.key,
  });

  final bool isSelected;
  final double iconSize;

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
            SvgPicture.asset(
              'assets/icons/home_notifications.svg',
              // ignore: deprecated_member_use
              color: isSelected ? clGreen : clWhite,
              height: iconSize,
              width: iconSize,
            ),
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
