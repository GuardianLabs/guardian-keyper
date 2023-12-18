import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

import 'online_status_text.dart';

class GuardianListTile extends StatelessWidget {
  final PeerId guardian;
  final bool? isSuccess;
  final bool isWaiting;
  final bool checkStatus;

  const GuardianListTile({
    required this.guardian,
    this.isSuccess,
    this.isWaiting = false,
    this.checkStatus = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        visualDensity: checkStatus
            ? const VisualDensity(vertical: VisualDensity.maximumDensity)
            : null,
        leading: checkStatus
            ? Column(children: [
                _buildLeading(),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: OnlineStatusText(peerId: guardian),
                ),
              ])
            : _buildLeading(),
        title: RichText(
          maxLines: 1,
          text: TextSpan(
            style: styleSourceSansPro614.copyWith(height: 1.5),
            children: buildTextWithId(
              id: guardian,
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
                margin: checkStatus ? paddingT20 : null,
                height: 20,
                width: 20,
                child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
              )
            : null,
      );

  Widget _buildLeading() => IconOf.shield(
        color: clWhite,
        bgColor: isSuccess == null
            ? null
            : isSuccess ?? false
                ? clGreen
                : clRed,
      );
}
