import 'package:flutter/gestures.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

import 'package:guardian_keyper/feature/vault/domain/entity/vault.dart';

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
  late TapGestureRecognizer _longPressRecognizer;

  @override
  void initState() {
    super.initState();
    _longPressRecognizer = TapGestureRecognizer()..onTap = () {};
  }

  @override
  void dispose() {
    _longPressRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.vault.hasQuorum
      ? const PageTitle(
          title: 'Guardians',
          subtitleSpans: [
            TextSpan(
              text: 'You`re unable to add a new Secrets '
                  'due to your limited vault access.',
            ),
            TextSpan(
              text: 'limited access',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        )
      : PageTitle(
          title: 'Almost done...',
          subtitleSpans: [
            TextSpan(
              text: 'Add at least '
                  '${widget.vault.missed} more '
                  'Guardian to complete the Recovery. '
                  'This will grant you ',
            ),
            const TextSpan(
              text: 'limited access',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
            const TextSpan(text: ' to Vault’s Secrets.'),
          ],
        );
}
