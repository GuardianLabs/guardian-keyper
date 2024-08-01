import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/feature/auth/ui/dialogs/on_ask_auth_dialog.dart';

import '../vault_secret_recovery_presenter.dart';

class ShowSecretPage extends StatelessWidget {
  static const _mask = SvgPicture(
    AssetBytesLoader(
      'assets/images/secret_mask.svg.vec',
    ),
  );

  static const _snack = 'Secret is copied to your clipboard.';

  const ShowSecretPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presenter = context.watch<VaultSecretRecoveryPresenter>();
    return ScaffoldSafe(
      appBar: AppBar(
        title: const Text('Successful Recovery'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          // Body
          Expanded(
            child: ListView(
              padding: paddingH20,
              children: [
                const PageTitle(
                  subtitle: 'Make sure your display is covered '
                      'before showing the Secret.',
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
                          padding: paddingB20,
                          child: presenter.isObfuscated
                              ? _mask
                              : Text(
                                  presenter.secret,
                                  style: theme.textTheme.bodySmall,
                                ),
                        ),
                        Row(children: [
                          Expanded(
                            child: presenter.isObfuscated
                                ? FilledButton(
                                    onPressed: () {
                                      if (!presenter.tryShow()) {
                                        OnAskAuthDialog.show(
                                          context,
                                          onUnlocked: presenter.onUnlockedShow,
                                        );
                                      }
                                    },
                                    child: const Text('Show'),
                                  )
                                : FilledButton(
                                    onPressed: presenter.onPressedHide,
                                    child: const Text('Hide'),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: FilledButton(
                              onPressed: () async {
                                final isOk = await presenter.tryCopy();
                                if (context.mounted) {
                                  if (isOk) {
                                    showSnackBar(context, text: _snack);
                                  } else {
                                    await OnAskAuthDialog.show(
                                      context,
                                      onUnlocked: () async {
                                        final isCopied =
                                            await presenter.onUnlockedCopy();
                                        if (isCopied && context.mounted) {
                                          showSnackBar(context, text: _snack);
                                        }
                                      },
                                    );
                                  }
                                }
                              },
                              child: const Text('Copy'),
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
      ),
    );
  }
}
