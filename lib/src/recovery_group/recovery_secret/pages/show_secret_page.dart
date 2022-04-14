import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
import '../../../core/widgets/icon_of.dart';

import '../../recovery_group_controller.dart';
import '../recovery_secret_controller.dart';

class ShowSecretPage extends StatefulWidget {
  const ShowSecretPage({Key? key}) : super(key: key);

  @override
  State<ShowSecretPage> createState() => _ShowSecretPageState();
}

class _ShowSecretPageState extends State<ShowSecretPage> {
  bool isSecretObfuscated = true;
  String secret = '';

  @override
  void initState() {
    super.initState();
    secret = context.read<RecoveryGroupController>().restoreSecret(
        context.read<RecoverySecretController>().shards.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Discovery peers',
          closeButton: HeaderBarCloseButton(),
        ),
        // Body
        const Padding(
          padding: EdgeInsets.only(top: 40, bottom: 10),
          child: IconOf.app(),
        ),
        const Text('This is your secret'),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Container(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: clIndigo800,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: const InputDecoration(isCollapsed: true),
                  maxLines: isSecretObfuscated ? 1 : 5,
                  readOnly: true,
                  obscureText: isSecretObfuscated,
                  controller: TextEditingController(text: secret),
                ),
                ElevatedButton(
                  child: isSecretObfuscated
                      ? const Text('Show Secret')
                      : const Text('Hide Secret'),
                  onPressed: () =>
                      setState(() => isSecretObfuscated = !isSecretObfuscated),
                ),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: PrimaryTextButton(
            text: 'Copy to Clipboard',
            onPressed: () async =>
                await Clipboard.setData(ClipboardData(text: secret)),
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
