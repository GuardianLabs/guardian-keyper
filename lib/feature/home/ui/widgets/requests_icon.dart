import 'package:get_it/get_it.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

class RequestsIcon extends StatelessWidget {
  const RequestsIcon({
    required this.isSelected,
    required this.iconSize,
    super.key,
  });

  final bool isSelected;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messageInteractor = GetIt.I<MessageInteractor>();
    return StreamBuilder(
      stream: messageInteractor.watch(),
      builder: (_, __) {
        final count =
            messageInteractor.messages.where((e) => e.isReceived).length;
        final icon = SvgPicture.asset(
          'assets/icons/home_requests.svg',
          colorFilter: ColorFilter.mode(
            isSelected
                ? theme.bottomNavigationBarTheme.selectedItemColor!
                : theme.bottomNavigationBarTheme.unselectedItemColor!,
            BlendMode.srcIn,
          ),
          height: iconSize,
          width: iconSize,
        );
        return count == 0
            ? icon
            : Badge.count(
                count: messageInteractor.messages
                    .where((e) => e.isReceived)
                    .length,
                backgroundColor: theme.extension<BrandColors>()!.dangerColor,
                textColor: theme.scaffoldBackgroundColor,
                child: icon,
              );
      },
    );
  }
}
