import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/common.dart';

import '../recover_secret_controller.dart';

class ShowSecretPage extends StatefulWidget {
  const ShowSecretPage({super.key});

  @override
  State<ShowSecretPage> createState() => _ShowSecretPageState();
}

class _ShowSecretPageState extends State<ShowSecretPage> {
  bool _isSecretObfuscated = true;
  String _secret = '';

  @override
  void initState() {
    super.initState();
    context
        .read<RecoverySecretController>()
        .getSecret()
        .then((value) => setState(() => _secret = value));
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Secret Recovery',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                const PageTitle(
                  title: 'Here’s your Secret',
                  subtitle: 'Make sure your display is covered if you want '
                      'to see your Secret.',
                ),
                // Secret
                Card(
                  child: Padding(
                    padding: paddingAll20,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 160,
                          padding: paddingBottom20,
                          child: _isSecretObfuscated
                              ? SvgPicture.asset(
                                  'assets/images/secret_mask.svg',
                                )
                              : Text(
                                  _secret,
                                  style: textStyleSourceSansPro414Purple,
                                ),
                        ),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              child:
                                  Text(_isSecretObfuscated ? 'Show' : 'Hide'),
                              onPressed: () => setState(() =>
                                  _isSecretObfuscated = !_isSecretObfuscated),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Copy',
                              onPressed: () async {
                                await Clipboard.setData(
                                    ClipboardData(text: _secret));
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  buildSnackBar(
                                    text: 'Secret is copied to your clipboard.',
                                  ),
                                );
                              },
                            ),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
