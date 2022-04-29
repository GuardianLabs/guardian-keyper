import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';

import '../settings_controller.dart';
import 'app_version.dart';

class HiddenCardWidget extends StatefulWidget {
  const HiddenCardWidget({Key? key}) : super(key: key);

  @override
  State<HiddenCardWidget> createState() => _HiddenCardWidgetState();
}

class _HiddenCardWidgetState extends State<HiddenCardWidget> {
  int _counter = 0;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
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
          maintainInteractivity: true,
          visible: _isVisible,
          child: Card(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(padding: paddingAll20, child: AppVersionWidget()),
              Padding(
                padding: paddingAll20,
                child: ElevatedButton(
                  child: const Text('Delete all trusted peers'),
                  onPressed:
                      context.read<SettingsController>().clearGuardianShards,
                ),
              ),
            ],
          )),
        ),
      );
}
