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
  late final _theme = Theme.of(context);

  @override
  void initState() {
    super.initState();
    final presenter = context.read<VaultGuardianAddPresenter>();
    presenter.startRequest().then((message) async {
      if (message.isAccepted) {
        showSnackBar(
          context,
          textSpans: [
            const TextSpan(text: 'You have successfully added '),
            TextSpan(text: message.peerId.name, style: styleW600),
            const TextSpan(text: 'as a Guardian for '),
            TextSpan(text: presenter.vaultId.name, style: styleW600),
          ],
        );
      } else if (message.isRejected) {
        await OnRejectDialog.show(context);
      } else {
        await OnFailDialog.show(context);
      }
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
    appBar: AppBar(
      title: const Text('Adding a Guardian'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Body
            const Padding(padding: EdgeInsets.only(top: 32)),
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
                      child: Text(
                        'Awaiting Guardian’s response',
                        style: _theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
  );
}
