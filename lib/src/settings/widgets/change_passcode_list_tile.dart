import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/widgets/auth/auth.dart';
import '/src/core/service/service_root.dart';
import '/src/core/repository/repository_root.dart';

class ChangePassCodeListTile extends StatelessWidget {
  const ChangePassCodeListTile({super.key});

  @override
  Widget build(final BuildContext context) {
    final settingsRepository = GetIt.I<RepositoryRoot>().settingsRepository;
    return ListTile(
      leading: const IconOf.passcode(),
      title: const Text('Passcode'),
      subtitle: Text(
        'Change authentication passcode',
        style: textStyleSourceSansPro414Purple,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded),
      onTap: () => settingsRepository.state.passCode.isEmpty
          ? showCreatePassCode(
              context: context,
              onConfirmed: settingsRepository.setPassCode,
              onVibrate: GetIt.I<ServiceRoot>().platformService.vibrate,
            )
          : showChangePassCode(
              context: context,
              onConfirmed: settingsRepository.setPassCode,
              currentPassCode: settingsRepository.state.passCode,
              onVibrate: GetIt.I<ServiceRoot>().platformService.vibrate,
            ),
    );
  }
}
