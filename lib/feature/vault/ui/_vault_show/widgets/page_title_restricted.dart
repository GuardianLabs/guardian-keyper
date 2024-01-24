import 'package:flutter/gestures.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

import '../dialogs/on_limited_access_dialog.dart';

class PageTitleRestricted extends StatefulWidget {
  const PageTitleRestricted({
    required this.vault,
    super.key,
  });

  final Vault vault;

  @override
  State<PageTitleRestricted> createState() => _PageTitleRestrictedState();
}

class _PageTitleRestrictedState extends State<PageTitleRestricted> {
  late final TapGestureRecognizer _tapRecognizer;

  late final _limitedAccessTapable = TextSpan(
    text: 'limited Safe access.',
    style: const TextStyle(
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
    ),
    recognizer: _tapRecognizer,
  );

  @override
  void initState() {
    super.initState();
    _tapRecognizer = TapGestureRecognizer()
      ..onTap = () => OnLimitedAccessDialog.show(context);
  }

  @override
  void dispose() {
    _tapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.vault.hasQuorum
      ? PageTitle(
          title: 'Guardians',
          subtitleSpans: [
            const TextSpan(
              text: 'You`re unable to add a new Secrets '
                  'due to your ',
            ),
            _limitedAccessTapable,
          ],
        )
      : PageTitle(
          title: 'Almost done...',
          subtitleSpans: [
            TextSpan(
              text: 'Add at least '
                  '${widget.vault.missed} more '
                  'Guardian${widget.vault.missed == 1 ? '' : 's'} to complete the Recovery. '
                  'This will grant you ',
            ),
            _limitedAccessTapable,
            const TextSpan(text: ' to Safe’s Secrets.'),
          ],
        );
}
