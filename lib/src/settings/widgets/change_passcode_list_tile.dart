import 'package:get_it/get_it.dart';

import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/auth/auth_case.dart';

class ChangePassCodeListTile extends StatelessWidget {
  const ChangePassCodeListTile({super.key});

  @override
  Widget build(final BuildContext context) => ListTile(
        leading: const IconOf.passcode(),
        title: const Text('Passcode'),
        subtitle: Text(
          'Change authentication passcode',
          style: textStyleSourceSansPro414Purple,
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () => GetIt.I<AuthCase>().changePassCode(context: context),
      );
}
