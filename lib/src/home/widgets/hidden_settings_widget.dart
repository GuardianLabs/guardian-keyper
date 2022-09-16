import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/di_container.dart';
import '/src/core/model/core_model.dart';

class HiddenSettingsWidget extends StatefulWidget {
  const HiddenSettingsWidget({super.key});

  @override
  State<HiddenSettingsWidget> createState() => _HiddenSettingsWidgetState();
}

class _HiddenSettingsWidgetState extends State<HiddenSettingsWidget> {
  late DIContainer _diContainer;
  int _counter = 0;
  bool _isVisible = false;

  @override
  void initState() {
    _diContainer = context.read<DIContainer>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _counter++;
          if (_counter > 5) {
            _counter = 0;
            setState(() => _isVisible = true);
          }
        },
        child: Visibility(
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          maintainInteractivity: false,
          visible: _isVisible,
          child: Card(
            child: Column(
              children: [
                // Toggle Proxy
                Padding(
                  padding: paddingV12,
                  child: ValueListenableBuilder<Box<SettingsModel>>(
                    valueListenable: _diContainer.boxSettings.listenable(),
                    builder: (_, boxSettings, __) => SwitchListTile.adaptive(
                      secondary: const IconOf.splitAndShare(),
                      title: const Text('Proxy connection'),
                      subtitle: const Text(
                          'Connect through Keyper-operated proxy server'),
                      value: boxSettings.isProxyEnabled,
                      onChanged: (isEnabled) {
                        _diContainer.boxSettings.isProxyEnabled = isEnabled;
                        isEnabled
                            ? _diContainer.networkService.setBootstrapServer(
                                _diContainer.globals.bsAddressV4,
                                _diContainer.globals.bsAddressV6)
                            : _diContainer.networkService
                                .setBootstrapServer(null, null);
                      },
                    ),
                  ),
                ),
                // Shows version
                Padding(
                  padding: paddingV12 + paddingH20,
                  child: FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (
                        context,
                        AsyncSnapshot<PackageInfo?> snapshot,
                      ) =>
                          Text(
                              'Version:  ${snapshot.data?.version}+${snapshot.data?.buildNumber}')),
                ),
              ],
            ),
          ),
        ),
      );
}
