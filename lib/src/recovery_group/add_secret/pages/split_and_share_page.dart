import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../add_secret_controller.dart';
import '../widgets/add_secret_close_button.dart';
import '../../widgets/guardian_tile_widget.dart';

class SplitAndShareSecretPage extends StatefulWidget {
  const SplitAndShareSecretPage({super.key});

  @override
  State<SplitAndShareSecretPage> createState() =>
      _SplitAndShareSecretPageState();
}

class _SplitAndShareSecretPageState extends State<SplitAndShareSecretPage> {
  late final StreamSubscription<ConnectivityResult> _subscription;
  bool _haveConnection = true;

  @override
  void initState() {
    super.initState();
    Connectivity().checkConnectivity().then((result) => setState(() =>
        _haveConnection = result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile));
    _subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) => setState(() => _haveConnection =
            result == ConnectivityResult.wifi ||
                result == ConnectivityResult.mobile));
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AddSecretController>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Split Secret',
          backButton: HeaderBarBackButton(
            onPressed: controller.previousScreen,
          ),
          closeButton: const AddSecretCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingH20,
            primary: true,
            shrinkWrap: true,
            children: [
              PageTitle(
                title: 'Split and share Secret with Guardians below',
                subtitleSpans: [
                  const TextSpan(
                    text: 'You are about to split your Secret in ',
                  ),
                  TextSpan(
                    text: '${controller.group.maxSize} encrypted Shards.',
                  ),
                  const TextSpan(
                    text: ' Each Guardian will receieve their own'
                        ' Shard which can be used to restore your Secret.',
                  ),
                ],
              ),
              Column(children: [
                for (final guardian in controller.group.guardians.keys)
                  Padding(
                    padding: paddingV6,
                    child: GuardianTileWidget(guardian: guardian),
                  )
              ]),
              // Open Settings Tile
              if (!_haveConnection)
                Padding(
                  padding: paddingTop20,
                  child: ListTile(
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
                    onTap: AppSettings.openWirelessSettings,
                  ),
                ),
              // Footer
              Padding(
                padding: paddingV32,
                child: PrimaryButton(
                  text: 'Continue',
                  onPressed: controller.nextScreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
