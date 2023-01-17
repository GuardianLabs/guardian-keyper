import '/src/core/di_container.dart';
import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

class ConnectionWidget extends StatelessWidget {
  const ConnectionWidget({super.key});

  @override
  Widget build(BuildContext context) => ListTile(
        leading: const Icon(
          Icons.error_outline,
          color: clYellow,
          size: 40,
        ),
        title: Text(
          'No connection',
          style: textStyleSourceSansPro614,
        ),
        subtitle: Text(
          'Connect to the Internet to continue',
          style: textStyleSourceSansPro414Purple,
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: context.read<DIContainer>().platformService.openWirelessSettings,
      );
}
