import 'dart:async';
import 'package:get_it/get_it.dart';

import 'package:guardian_keyper/ui/widgets/emoji.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

import '../../domain/message_interactor.dart';
import '../widgets/request_panel.dart';
import 'message_titles_mixin.dart';

class OnMessageActiveDialog extends StatefulWidget with MessageTitlesMixin {
  static Future<bool?> show({
    required final BuildContext context,
    required final MessageModel message,
  }) =>
      showModalBottomSheet<bool>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        builder: (_) => OnMessageActiveDialog(message: message),
      );

  final MessageModel message;

  const OnMessageActiveDialog({super.key, required this.message});

  @override
  State<OnMessageActiveDialog> createState() => _OnMessageActiveDialogState();
}

class _OnMessageActiveDialogState extends State<OnMessageActiveDialog>
    with TickerProviderStateMixin {
  final _messagesInteractor = GetIt.I<MessageInteractor>();

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
                : RequestPanel(
                    peerId: widget.message.peerId,
                    isPeerOnline: _isPeerOnline,
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
