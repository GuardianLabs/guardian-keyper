import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_guardian_add_presenter.dart';
import '../dialogs/on_fail_dialog.dart';
import '../dialogs/on_reject_dialog.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final _presenter = context.read<VaultGuardianAddPresenter>();

  @override
  void initState() {
    super.initState();
    _presenter.startRequest().then((message) async {
      if (message.isAccepted) {
        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBar(
            textSpans: [
              ...buildTextWithId(
                name: message.peerId.name,
                leadingText: 'You have successfully added ',
              ),
              ...buildTextWithId(
                name: _presenter.vaultId.name,
                leadingText: 'as a Guardian for ',
              ),
            ],
          ),
        );
      } else if (message.isRejected) {
        await OnRejectDialog.show(context);
      } else {
        await OnFailDialog.show(context);
      }
      if (context.mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          const HeaderBar(
            caption: 'Adding a Guardian',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          const Padding(padding: paddingT32),
          Padding(
            padding: paddingH20,
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: paddingT20,
                    child: Selector<VaultGuardianAddPresenter, bool>(
                      selector: (_, presenter) => presenter.isWaiting,
                      builder: (_, isWaiting, __) => Visibility(
                        visible: isWaiting,
                        child: const CircularProgressIndicator.adaptive(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: paddingAll20,
                    child: RichText(
                      text: TextSpan(
                        style: styleSourceSansPro616,
                        children: buildTextWithId(
                          leadingText: 'Awaiting ',
                          name: _presenter.qrCode!.peerId.name,
                          trailingText: '’s response',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}
