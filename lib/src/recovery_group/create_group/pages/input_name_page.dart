import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/model/core_model.dart';

import '../create_group_controller.dart';
import '../../edit_group/recovery_group_edit_view.dart';

class InputNamePage extends StatelessWidget {
  const InputNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateGroupController>(context);
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add Name',
          backButton: HeaderBarBackButton(onPressed: controller.previousScreen),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
            child: ListView(
          padding: paddingH20,
          children: [
            const PageTitle(title: 'Create a name for your Recovery Group'),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.text,
              maxLength: controller.diContainer.globals.maxNameLength,
              decoration: const InputDecoration(labelText: ' Group name '),
              onChanged: (value) => controller.groupName = value,
            ),
            // Footer
            Padding(
              padding: paddingV32,
              child: PrimaryButton(
                text: 'Continue',
                onPressed: controller.groupName.isEmpty
                    ? null
                    : () async => Navigator.popAndPushNamed(
                          context,
                          RecoveryGroupEditView.routeName,
                          arguments:
                              (await controller.addGroup(RecoveryGroupModel(
                            id: GroupId.aNew(),
                            name: controller.groupName,
                            type: controller.groupType!,
                            maxSize: controller.groupSize,
                          )))
                                  .id,
                        ),
              ),
            ),
          ],
        )),
      ],
    );
  }
}
