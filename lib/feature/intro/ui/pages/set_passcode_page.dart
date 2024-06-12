import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/auth/ui/dialogs/on_create_pass_code.dart';

import '../intro_presenter.dart';

class SetPasscodePage extends StatefulWidget {
  const SetPasscodePage({super.key});

  @override
  State<SetPasscodePage> createState() => _SetPasscodePageState();
}

class _SetPasscodePageState extends State<SetPasscodePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await OnCreatePassCodeDialog.show(context);
      if (mounted) {
        final presenter = context.read<IntroPresenter>();
        presenter.hasBiometrics
            ? presenter.nextPage()
            : Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.surfaceTint);
}
