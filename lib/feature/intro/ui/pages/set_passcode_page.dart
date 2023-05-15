import 'package:guardian_keyper/ui/widgets/common.dart';

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
    Future.microtask(
      () => context.read<IntroPresenter>().createPassCode(context: context),
    );
  }

  @override
  Widget build(BuildContext context) =>
      Container(color: Theme.of(context).colorScheme.background);
}
