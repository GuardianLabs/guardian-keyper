import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '/src/core/ui/widgets/common.dart';

import '../vault_recover_secret_controller.dart';

class ShowSecretPage extends StatefulWidget {
  const ShowSecretPage({super.key});

  @override
  State<ShowSecretPage> createState() => _ShowSecretPageState();
}

class _ShowSecretPageState extends State<ShowSecretPage> {
  final _copiedSnackbar = buildSnackBar(
    text: 'Secret is copied to your clipboard.',
  );
  late final _controller = context.read<VaultRecoverySecretController>();

  bool _isObfuscated = true;
  bool _isAuthorized = false;

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
                          child: _isObfuscated
                              ? SvgPicture.asset(
                                  'assets/images/secret_mask.svg',
                                )
                              : Text(
                                  _controller.secret,
                                  style: textStyleSourceSansPro414Purple,
                                ),
                        ),
                        Row(children: [
                          Expanded(
                            child: _isObfuscated
                                ? ElevatedButton(
                                    onPressed: onPressedShow,
                                    child: const Text('Show'),
                                  )
                                : ElevatedButton(
                                    onPressed: onPressedHide,
                                    child: const Text('Hide'),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              text: 'Copy',
                              onPressed: _onPressedCopy,
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

  void onPressedShow() {
    _isAuthorized
        ? setState(() {
            _isObfuscated = false;
          })
        : _controller.checkPassCode(
            context: context,
            onUnlocked: () => setState(
              () {
                _isObfuscated = false;
                _isAuthorized = true;
              },
            ),
          );
  }

  void onPressedHide() => setState(() {
        _isObfuscated = true;
      });

  void _onPressedCopy() async {
    if (_isAuthorized) {
      await Clipboard.setData(
        ClipboardData(text: _controller.secret),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(_copiedSnackbar);
      }
    } else {
      _controller.checkPassCode(
        context: context,
        onUnlocked: () async {
          _isAuthorized = true;
          await Clipboard.setData(ClipboardData(text: _controller.secret));
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(_copiedSnackbar);
          }
        },
      );
    }
  }
}
