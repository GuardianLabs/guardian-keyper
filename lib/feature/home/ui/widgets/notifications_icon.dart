import 'package:get_it/get_it.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';
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
    final theme = Theme.of(context);
    final brandColors = theme.extension<BrandColors>()!;
    final messageInteractor = GetIt.I<MessageInteractor>();
    return StreamBuilder(
      stream: messageInteractor.watch(),
      builder: (_, __) => Badge.count(
        count: messageInteractor.messages.where((e) => e.isReceived).length,
        backgroundColor: brandColors.dangerColor,
        textColor: theme.scaffoldBackgroundColor,
        child: SvgPicture.asset(
          'assets/icons/home_notifications.svg',
          colorFilter: isSelected
              ? ColorFilter.mode(brandColors.highlightColor, BlendMode.srcIn)
              : null,
          height: iconSize,
          width: iconSize,
        ),
      ),
    );
  }
}
