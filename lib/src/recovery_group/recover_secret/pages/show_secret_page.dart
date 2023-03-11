import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/widgets/common.dart';

import '../recover_secret_controller.dart';

class ShowSecretPage extends StatefulWidget {
  const ShowSecretPage({super.key});

  @override
  State<ShowSecretPage> createState() => _ShowSecretPageState();
}

class _ShowSecretPageState extends State<ShowSecretPage> {
  bool _isSecretObfuscated = true;

  @override
  Widget build(final BuildContext context) => Column(
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
                                  context
                                      .read<RecoverySecretController>()
                                      .secret,
                                  style: textStyleSourceSansPro414Purple,
                                ),
                        ),
                        Row(children: [
                          Expanded(
                            child: ElevatedButton(
                              child:
                                  Text(_isSecretObfuscated ? 'Show' : 'Hide'),
                              // TBD: ask passCode before show
                              onPressed: () => setState(() =>
                                  _isSecretObfuscated = !_isSecretObfuscated),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Copy',
                              // TBD: ask passCode before copy
                              onPressed: () async {
                                await Clipboard.setData(
                                  ClipboardData(
                                      text: context
                                          .read<RecoverySecretController>()
                                          .secret),
                                );
                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(buildSnackBar(
                                    text: 'Secret is copied to your clipboard.',
                                  ));
                                }
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
