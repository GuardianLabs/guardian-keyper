import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

class GuardianListTileOld extends StatelessWidget {
  final PeerId guardian;
  final bool? isSuccess;
  final bool isWaiting;

  const GuardianListTileOld({
    required this.guardian,
    this.isSuccess,
    this.isWaiting = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        leading: IconOf.shield(
          color: clWhite,
          bgColor: isSuccess == null
              ? null
              : isSuccess ?? false
                  ? clGreen
                  : clRed,
        ),
        title: RichText(
          maxLines: 1,
          text: TextSpan(
            style: styleSourceSansPro614.copyWith(height: 1.5),
            children: buildTextWithId(
              name: guardian.name,
              style: TextStyle(
                color: guardian.token.isEmpty
                    ? clRed
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        subtitle: Text(
          guardian.toHexShort(),
          maxLines: 1,
          style: styleSourceSansPro414Purple,
        ),
        trailing: isWaiting
            ? Container(
                alignment: Alignment.centerRight,
                height: 20,
                width: 20,
                child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : null,
      );
}
