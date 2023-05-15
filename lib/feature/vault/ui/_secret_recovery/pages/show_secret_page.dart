import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/utils/utils.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

import '../vault_secret_recovery_presenter.dart';

class ShowSecretPage extends StatelessWidget {
  const ShowSecretPage({super.key});

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
                    child: Consumer<VaultSecretRecoveryPresenter>(
                      builder: (
                        BuildContext context,
                        final VaultSecretRecoveryPresenter presenter,
                        final Widget? widget,
                      ) =>
                          Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            height: 160,
                            padding: paddingBottom20,
                            child: presenter.isObfuscated
                                ? const SvgPicture(AssetBytesLoader(
                                    'assets/images/secret_mask.svg.vec',
                                  ))
                                : Text(
                                    presenter.secret,
                                    style: textStyleSourceSansPro414Purple,
                                  ),
                          ),
                          Row(children: [
                            Expanded(
                              child: presenter.isObfuscated
                                  ? ElevatedButton(
                                      onPressed: () => presenter.onPressedShow(
                                        context: context,
                                      ),
                                      child: const Text('Show'),
                                    )
                                  : ElevatedButton(
                                      onPressed: presenter.onPressedHide,
                                      child: const Text('Hide'),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Copy',
                                onPressed: () => presenter.onPressedCopy(
                                  context: context,
                                  snackBar: buildSnackBar(
                                    text: 'Secret is copied to your clipboard.',
                                  ),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
