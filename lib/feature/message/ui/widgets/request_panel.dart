import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';

class RequestPanel extends StatelessWidget {
  const RequestPanel({
    super.key,
    required this.peerId,
    required this.isPeerOnline,
  });

  final bool isPeerOnline;
  final PeerId peerId;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const IconOf.shield(color: clWhite),
              Padding(
                padding: paddingT12,
                child: isPeerOnline
                    ? Text(
                        'Online',
                        style: styleSourceSansPro612.copyWith(
                          color: clGreen,
                        ),
                      )
                    : Text(
                        'Offline',
                        style: styleSourceSansPro612.copyWith(
                          color: clRed,
                        ),
                      ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  style: styleSourceSansPro416Purple,
                  children: [
                    const TextSpan(
                      text: 'To approve or reject the request,'
                          ' both users must run the app ',
                    ),
                    TextSpan(
                      text: 'at the same time',
                      style: styleSourceSansPro616,
                    ),
                    ...buildTextWithId(
                      leadingText: '. Ask ',
                      id: peerId,
                      trailingText: ' to log in.',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
}
