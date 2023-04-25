import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/src/core/ui/widgets/emoji.dart';
import 'package:guardian_keyper/src/core/ui/widgets/common.dart';
import 'package:guardian_keyper/src/core/ui/widgets/icon_of.dart';

import '../../domain/message_model.dart';
import '../../domain/messages_interactor.dart';
import 'message_titles_mixin.dart';

class MessageActiveDialog extends StatefulWidget with MessageTitlesMixin {
  static Future<bool?> show({
    required final BuildContext context,
    required final MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (final BuildContext context) =>
            MessageActiveDialog(message: message),
      );

  final MessageModel message;

  const MessageActiveDialog({super.key, required this.message});

  @override
  State<MessageActiveDialog> createState() => _MessageActiveDialogState();
}

class _MessageActiveDialogState extends State<MessageActiveDialog>
    with TickerProviderStateMixin {
  final _messagesInteractor = GetIt.I<MessagesInteractor>();

  late final _animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  late final _timer = Timer.periodic(
    _messagesInteractor.messageTTL,
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
  Widget build(final BuildContext context) => BottomSheetWidget(
        titleString: widget.getTitle(widget.message),
        textSpan: [
          ...buildTextWithId(id: widget.message.peerId),
          TextSpan(
            text: widget.getSubtitle(widget.message),
          ),
          ...buildTextWithId(id: widget.message.vaultId),
        ],
        body: Padding(
          padding: paddingV20,
          child: Container(
            decoration: boxDecoration,
            padding: paddingAll20,
            height: 120,
            child: _isRequestError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Connection Error',
                        style: textStyleSourceSansPro616,
                      ),
                      Padding(
                        padding: paddingV12,
                        child: Text(
                          'Something went wrong. Please try again.',
                          style: textStyleSourceSansPro416Purple,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: _animationController.value,
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const IconOf.shield(color: clWhite),
                          Padding(
                            padding: paddingTop12,
                            child: _isPeerOnline
                                ? Text(
                                    'Online',
                                    style: textStyleSourceSansPro612.copyWith(
                                      color: clGreen,
                                    ),
                                  )
                                : Text(
                                    'Offline',
                                    style: textStyleSourceSansPro612.copyWith(
                                      color: clRed,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: RichText(
                            softWrap: true,
                            text: TextSpan(
                              style: textStyleSourceSansPro416Purple,
                              children: [
                                const TextSpan(
                                  text: 'To approve or reject the request,'
                                      ' both users must run the app ',
                                ),
                                TextSpan(
                                  text: 'at the same time',
                                  style: textStyleSourceSansPro616,
                                ),
                                ...buildTextWithId(
                                  leadingText: '. Ask ',
                                  id: widget.message.peerId,
                                  trailingText: ' to log in.',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        footer: Row(children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isPeerOnline && !_isRequestError && !_isRequestActive
                  ? () => _sendRespone(MessageStatus.rejected)
                  : null,
              child: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: PrimaryButton(
              onPressed: _isPeerOnline && !_isRequestError && !_isRequestActive
                  ? () => _sendRespone(MessageStatus.accepted)
                  : null,
              text: 'Approve',
            ),
          ),
        ]),
      );

  Future<void> _sendRespone(final MessageStatus status) async {
    final response = widget.message.copyWith(status: status);
    setState(() => _isRequestActive = true);
    try {
      // TBD: move to presenter
      await GetIt.I<MessagesInteractor>().sendRespone(response);
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
