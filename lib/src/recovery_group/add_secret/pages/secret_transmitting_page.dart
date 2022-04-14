import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
// import '../../../core/widgets/icon_of.dart';

import '../../recovery_group_model.dart';
import '../add_secret_controller.dart';
import '../../recovery_group_controller.dart';

class SecretTransmittingPage extends StatefulWidget {
  const SecretTransmittingPage({Key? key}) : super(key: key);

  @override
  State<SecretTransmittingPage> createState() => _SecretTransmittingPageState();
}

class _SecretTransmittingPageState extends State<SecretTransmittingPage> {
  Timer _timer = Timer(const Duration(seconds: 5), (() {}));
  bool _isWaiting = true;

  void _initTimer() {
    if (_timer.isActive) _timer.cancel();
    _timer = Timer(
      const Duration(seconds: 5),
      () => setState(() => _isWaiting = false),
    );
  }

  @override
  void initState() {
    super.initState();
    final controller = context.read<RecoveryGroupController>();
    final state = context.read<AddSecretController>();
    final recoveryGroup = controller.groups[state.groupName]!;
    _initTimer();
    controller.distributeShards(
      state.shards,
      recoveryGroup.name,
      state.secret,
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RecoveryGroupController>();
    final state = Provider.of<AddSecretController>(context);
    final recoveryGroup = controller.groups[state.groupName]!;
    final isFinished = state.shards.isEmpty;

    if (isFinished) {
      _isWaiting = false;
      _timer.cancel();
    }
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Distribute Secret',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: Icon(Icons.key_outlined, size: 40),
        ),
        const Text('The secret is being sharded and transmitted ',
            textAlign: TextAlign.center),
        if (_isWaiting)
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Align(child: CircularProgressIndicator()),
          ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              state.error = null;
              state.stackTrace = null;
              if (_isWaiting) return;
              _initTimer();
              controller.distributeShards(
                state.shards,
                recoveryGroup.name,
                state.secret,
              );
            },
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                for (var guardian in recoveryGroup.guardians.values)
                  GuardianListTileWidget(
                    name: guardian.name,
                    code: guardian.pubKey.toString(),
                    tag: guardian.tag,
                    // nameColor: guardian.code.isEmpty ? clRed : clWhite,
                    iconColor: state.shards.containsKey(guardian.pubKey)
                        ? clIndigo500
                        : clGreen,
                    status: state.shards.containsKey(guardian.pubKey)
                        ? clYellow
                        : null,
                  ),
                if (state.error != null) Text('Error: ${state.error}'),
                if (state.stackTrace != null)
                  Text('Stack Trace: ${state.stackTrace}'),
              ],
            ),
          ),
        ),
        // Footer
        if (isFinished)
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: PrimaryTextButton(
              text: 'Done',
              onPressed: () {
                context.read<RecoveryGroupController>().addSecret(
                    state.groupName,
                    RecoveryGroupSecretModel(
                      name: 'TheOne',
                      token: state.secret,
                    ));
                Navigator.of(context).pop();
              },
            ),
          ),
        Container(height: 50),
      ],
    );
  }
}
