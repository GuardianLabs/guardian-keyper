import '/src/core/consts.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import 'guardian_tile_with_ping_widget.dart';

class AddGuardianWidget extends StatelessWidget {
  final RecoveryGroupModel group;

  const AddGuardianWidget({super.key, required this.group});

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          Padding(
            padding: paddingBottom12,
            child: Text(
              'Add your Guardians',
              style: textStylePoppins620,
              textAlign: TextAlign.center,
            ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Add ${group.maxSize - group.size} more Guardian',
                  style: textStyleBold,
                ),
                TextSpan(
                  text: ' to the group via QR Code to enable '
                      'your Vault and secure your Secret.',
                  style: textStyleSourceSansPro416,
                ),
              ],
            ),
          ),
          Padding(
            padding: paddingV32,
            child: PrimaryButton(
              text: 'Add via QR Code',
              onPressed: () => Navigator.of(context).pushNamed(
                routeGroupAddGuardian,
                arguments: group.id,
              ),
            ),
          ),
          for (final guardian in group.guardians.keys)
            Padding(
              padding: paddingV6,
              child: GuardianTileWithPingWidget(guardian: guardian),
            ),
        ],
      );
}
