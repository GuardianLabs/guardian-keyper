import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

class GuardianSelfListTile extends StatelessWidget {
  const GuardianSelfListTile({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite, bgColor: clGreen),
        title: Text(
          'Secret Shard stored on my device',
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: styleSourceSansPro614.copyWith(height: 1.5),
        ),
        subtitle: Text(
          'Acts as a Guardian’s approval',
          maxLines: 1,
          style: styleSourceSansPro414Purple,
        ),
      );
}
