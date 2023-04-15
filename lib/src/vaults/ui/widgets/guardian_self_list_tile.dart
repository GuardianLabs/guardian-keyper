import '/src/core/data/core_model.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/ui/widgets/icon_of.dart';

class GuardianSelfListTile extends StatelessWidget {
  final PeerId guardian;

  const GuardianSelfListTile({super.key, required this.guardian});

  @override
  Widget build(final BuildContext context) => ListTile(
        leading: const IconOf.shield(color: clWhite, bgColor: clGreen),
        title: Text(
          'Secret Shard stored on my device',
          maxLines: 1,
          overflow: TextOverflow.fade,
          style: textStyleSourceSansPro614.copyWith(height: 1.5),
        ),
        subtitle: Text(
          'Acts as a Guardian’s approval',
          maxLines: 1,
          style: textStyleSourceSansPro414Purple,
        ),
      );
}
