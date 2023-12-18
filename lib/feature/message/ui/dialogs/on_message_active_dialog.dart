import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/theme/brand_colors.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/message/domain/use_case/message_interactor.dart';

import 'message_text_mixin.dart';

class OnMessageActiveDialog extends StatefulWidget with MessageTextMixin {
  static Future<bool?> show(
    BuildContext context, {
    required MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnMessageActiveDialog(message: message),
      );

  const OnMessageActiveDialog({
    required this.message,
    super.key,
  });

  final MessageModel message;

  @override
  State<OnMessageActiveDialog> createState() => _OnMessageActiveDialogState();
}

class _OnMessageActiveDialogState extends State<OnMessageActiveDialog>
    with TickerProviderStateMixin {
  final _messagesInteractor = GetIt.I<MessageInteractor>();

  late final _theme = Theme.of(context);
  late final _brandColors = _theme.extension<BrandColors>()!;

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  late final _timer = Timer.periodic(
    retryNetworkTimeout,
    (_) {
      _messagesInteractor.pingPeer(widget.message.peerId).then(
        (isOnline) {
          if (mounted) setState(() => _isPeerOnline = isOnline);
        },
      );
    },
  );

  late bool _isPeerOnline =
      _messagesInteractor.getPeerStatus(widget.message.peerId);

  bool _isRequestError = false;
  bool _isRequestActive = false;

  @override
  void initState() {
    super.initState();
    _timer.isActive;
    _animationController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        // Title
        titleString: widget.getTitle(widget.message),
        // Subtitle
        textSpan: [
          TextSpan(text: widget.message.peerId.name, style: styleW600),
          TextSpan(text: widget.getSubtitle(widget.message)),
          TextSpan(text: widget.message.vaultId.name, style: styleW600),
        ],
        // Card
        body: Card(
          child: Padding(
            padding: paddingAll20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _isRequestError
                  // Error
                  ? [
                      Text(
                        'Connection Error',
                        style: _theme.textTheme.bodyMedium,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Something went wrong. Please try again.'),
                      ),
                      LinearProgressIndicator(
                        value: _animationController.value,
                      ),
                    ]
                  // Peer status
                  : [
                      Text(
                        widget.message.peerId.name,
                        style: _theme.textTheme.bodySmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _isPeerOnline
                            ? Text(
                                'Online',
                                style: _theme.textTheme.labelMedium?.copyWith(
                                  color: _brandColors.highlightColor,
                                ),
                              )
                            : Text(
                                'Offline',
                                style: _theme.textTheme.labelMedium?.copyWith(
                                  color: _brandColors.dangerColor,
                                ),
                              ),
                      ),
                      const Text(
                        'To approve or reject the request, both '
                        'Owner and Guardian must run the app at the same time. '
                        'Ask the Owner to log into the app.',
                        textAlign: TextAlign.center,
                      ),
                    ],
            ),
          ),
        ),
        // Buttons
        footer: Row(children: [
          Expanded(
            child: FilledButton(
              onPressed: _isPeerOnline && !_isRequestError && !_isRequestActive
                  ? () => _sendRespone(MessageStatus.rejected)
                  : null,
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: _isPeerOnline && !_isRequestError && !_isRequestActive
                  ? () => _sendRespone(MessageStatus.accepted)
                  : null,
              child: const Text('Approve'),
            ),
          ),
        ]),
      );

  Future<void> _sendRespone(MessageStatus status) async {
    final response = widget.message.copyWith(status: status);
    setState(() => _isRequestActive = true);
    try {
      await _messagesInteractor.sendRespone(response);
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      _animationController
          .forward()
          .then((_) => setState(() => _isRequestError = false));
      setState(() {
        _isRequestError = true;
        _isRequestActive = false;
      });
    }
  }
}
