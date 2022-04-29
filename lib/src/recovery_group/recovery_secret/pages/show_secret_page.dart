import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../recovery_secret_controller.dart';

class ShowSecretPage extends StatefulWidget {
  const ShowSecretPage({Key? key}) : super(key: key);

  @override
  State<ShowSecretPage> createState() => _ShowSecretPageState();
}

class _ShowSecretPageState extends State<ShowSecretPage> {
  final _ctrl = TextEditingController();
  bool isSecretObfuscated = true;

  @override
  void initState() {
    super.initState();
    _ctrl.text = context.read<RecoverySecretController>().secret;
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        const HeaderBar(closeButton: HeaderBarCloseButton()),
        // Body
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          padding: paddingH20,
          children: [
            // Icon
            const PaddingTop(child: IconOf.secret(radius: 40, size: 40)),
            // Text
            Padding(
              padding: paddingTop20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'This is your ',
                      style: textStylePoppinsBold20,
                    ),
                    TextSpan(
                      text: 'secret',
                      style: textStylePoppinsBold20Blue,
                    ),
                  ],
                ),
              ),
            ),
            // Secret
            Padding(
              padding: paddingTop40,
              child: Card(
                child: Padding(
                  padding: paddingAll20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _ctrl,
                        maxLines: isSecretObfuscated ? 1 : null,
                        readOnly: true,
                        obscureText: isSecretObfuscated,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        child: isSecretObfuscated
                            ? const Text('Show Secret')
                            : const Text('Hide Secret'),
                        onPressed: () => setState(
                            () => isSecretObfuscated = !isSecretObfuscated),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
            text: 'Copy',
            onPressed: () async =>
                await Clipboard.setData(ClipboardData(text: _ctrl.value.text)),
          ),
        ),
      ],
    );
  }
}
