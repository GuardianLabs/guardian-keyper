import '/src/core/ui/widgets/common.dart';

import '../create_group_controller.dart';
import '../widgets/guardian_count_radio.dart';

class GuardiansControlPanel extends StatelessWidget {
  const GuardiansControlPanel({super.key});

  @override
  Widget build(final BuildContext context) {
    final controller = Provider.of<CreateGroupController>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: clIndigo800,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: GuardianCountRadio(
                    groupSize: 3,
                    groupThreshold: 2,
                    isChecked: controller.groupSize == 3,
                  ),
                ),
                Expanded(
                  child: GuardianCountRadio(
                    groupSize: 5,
                    groupThreshold: 3,
                    isChecked: controller.groupSize == 5,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    'Keep one Shard (encrypted part of a Secret) on my device '
                    'every time I create a new Secret.',
                    softWrap: true,
                    style: textStyleSourceSansPro412Purple,
                  ),
                ),
                Switch.adaptive(
                  value: controller.isGroupMember,
                  onChanged: (value) => controller.isGroupMember = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
