import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

class AddSecretButton extends StatelessWidget {
  const AddSecretButton({super.key, required this.group});

  final RecoveryGroupModel group;

  @override
  Widget build(BuildContext context) => PrimaryButton(
        text: 'Add a Secret',
        onPressed: () => Navigator.of(context).pushNamed(
          '/recovery_group/add_secret',
          arguments: group.id,
        ),
      );
}
