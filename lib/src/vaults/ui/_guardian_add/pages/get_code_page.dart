import 'package:guardian_keyper/src/core/consts.dart';
import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';

import '../presenters/vault_guardian_add_presenter.dart';
import '../dialogs/on_duplicate_dialog.dart';
import '../../dialogs/on_version_high.dart';
import '../../dialogs/on_version_low.dart';
import '../dialogs/on_fail_dialog.dart';

class GetCodePage extends StatefulWidget {
  const GetCodePage({super.key});

  @override
  State<GetCodePage> createState() => _GetCodePageState();
}

class _GetCodePageState extends State<GetCodePage> with WidgetsBindingObserver {
  late final _presenter = context.read<VaultGuardianAddPresenter>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _presenter.checkClipboard();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) _presenter.checkClipboard();
  }

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // Header
          HeaderBar(
            captionSpans: buildTextWithId(id: _presenter.vaultId),
            closeButton: const HeaderBarCloseButton(),
          ),
          // Body
          PageTitle(
            title: 'Add your Guardians',
            subtitleSpans: [
              TextSpan(
                style: textStyleSourceSansPro616Purple,
                text: 'Add Guardian(s) ',
              ),
              TextSpan(
                style: textStyleSourceSansPro416Purple,
                text: 'to enable your Vault and secure your Secrets.',
              ),
            ],
          ),
          Padding(
            padding: paddingH20,
            child: PrimaryButton(
              text: 'Add via a QR Code',
              onPressed: () => Navigator.of(context)
                  .pushNamed<String?>(routeScanQrCode)
                  .then(_setCode),
            ),
          ),
          Padding(
            padding: paddingAll20,
            child: Selector<VaultGuardianAddPresenter, bool>(
              selector: (
                final BuildContext context,
                final VaultGuardianAddPresenter presenter,
              ) =>
                  presenter.canUseClipboard,
              builder: (
                final BuildContext context,
                final bool canUseClipboard,
                final Widget? widget,
              ) =>
                  PrimaryButton(
                text: 'Add via a Text Code',
                onPressed: canUseClipboard
                    ? () => _presenter.getCodeFromClipboard().then(_setCode)
                    : null,
              ),
            ),
          ),
        ],
      );

  void _setCode(final String? code) {
    try {
      _presenter.setCode(code);
    } on SetCodeFailException {
      OnFailDialog.show(context);
    } on SetCodeVersionLowException {
      OnVersionLowDialog.show(context);
    } on SetCodeVersionHighException {
      OnVersionHighDialog.show(context);
    } on SetCodeDuplicateException catch (e) {
      OnDuplicateDialog.show(context, e.message);
    }
  }
}
