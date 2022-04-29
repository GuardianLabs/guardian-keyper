import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../settings_controller.dart';

class DeviceNamePage extends StatefulWidget {
  const DeviceNamePage({Key? key}) : super(key: key);

  @override
  State<DeviceNamePage> createState() => _DeviceNamePageState();
}

class _DeviceNamePageState extends State<DeviceNamePage> {
  String _deviceName = '';
  final _ctrl = TextEditingController();

  @override
  void initState() {
    _deviceName = context.read<SettingsController>().deviceName;
    _ctrl.text = _deviceName;
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Your Device Name',
            backButton: HeaderBarBackButton(),
          ),
          // Body
          Padding(
              padding: paddingAll20,
              child: TextField(
                autofocus: true,
                controller: _ctrl,
                keyboardType: TextInputType.name,
                decoration:
                    const InputDecoration(labelText: ' YOUR DEVICE NAME '),
                onChanged: (value) => setState(() => _deviceName = value),
              )),
          Expanded(child: Container()),
          // Footer
          Padding(
            padding: paddingFooter,
            child: PrimaryButtonBig(
                text: 'Change Name',
                onPressed: () async {
                  await context
                      .read<SettingsController>()
                      .setDeviceName(_deviceName);
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => BottomSheetWidget(
                            icon: const IconOf.nameChanged(
                              radius: 40,
                              size: 40,
                              bage: BageType.ok,
                            ),
                            titleString: 'Device name changed',
                            textString:
                                'Your device name was\nchanged successfully.',
                            footer: PrimaryButtonBig(
                              text: 'Done',
                              onPressed: Navigator.of(context).pop,
                            ),
                          ));
                }),
          ),
        ],
      )),
    );
  }
}
