import 'dart:async';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

import '../guardian_controller.dart';

class MessageActionWidget extends StatefulWidget {
  final String title;
  final MessageModel message;

  const MessageActionWidget({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  State<MessageActionWidget> createState() => _MessageActionWidgetState();
}

class _MessageActionWidgetState extends State<MessageActionWidget>
    with TickerProviderStateMixin {
  static const _subtitles = {
    OperationType.authPeer: ' asks you to become a Guardian for ',
    OperationType.setShard: ' asks you to accept the Secret Shard for ',
    OperationType.getShard: ' asks you to approve a recovery of Secret for ',
    OperationType.takeOwnership:
        ' asks you to approve a change of ownership for ',
  };
  late final StreamSubscription<bool> _peerStatusSubscription;
  late final AnimationController _animationController;
  bool _isPeerOnline = false;
  bool _isRequestError = false;
  bool _isRequestActive = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() => setState(() {}));

    final networkService =
        context.read<GuardianController>().diContainer.networkService;

    networkService
        .pingPeer(peerId: widget.message.peerId)
        .then((isOnline) => setState(() => _isPeerOnline = isOnline));

    _peerStatusSubscription = networkService.onPeerStatusChanged(
      (isOnline) => setState(() => _isPeerOnline = isOnline),
      widget.message.peerId,
    );
    super.initState();
  }

  @override
  void dispose() {
    _peerStatusSubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BottomSheetWidget(
        titleString: widget.title,
        textSpan: [
          TextSpan(
            text: widget.message.secretShard.ownerName,
            style: textStyleSourceSansPro616,
          ),
          TextSpan(
            text: _subtitles[widget.message.type]!,
          ),
          TextSpan(
            text: widget.message.secretShard.groupName,
            style: textStyleSourceSansPro616,
          ),
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
                      Text('Connection Error',
                          style: textStyleSourceSansPro616),
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
                                ? Text('Online',
                                    style: textStyleSourceSansPro612.copyWith(
                                        color: clGreen))
                                : Text('Offline',
                                    style: textStyleSourceSansPro612.copyWith(
                                        color: clRed)),
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
                                TextSpan(
                                  text: '. Ask '
                                      '${widget.message.secretShard.ownerName}'
                                      ' to log in.',
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
                ? () async => await _sendRespone(MessageStatus.rejected)
                : null,
            child: const Text('Reject'),
          )),
          const SizedBox(width: 10),
          Expanded(
              child: PrimaryButton(
            onPressed: _isPeerOnline && !_isRequestError && !_isRequestActive
                ? () async => await _sendRespone(MessageStatus.accepted)
                : null,
            text: 'Approve',
          )),
        ]),
      );

  Future<void> _sendRespone(MessageStatus status) async {
    final response = widget.message.copyWith(status: status);
    setState(() => _isRequestActive = true);
    try {
      final controller = context.read<GuardianController>();
      switch (response.type) {
        case OperationType.authPeer:
          await controller.sendAuthPeerResponse(response);
          break;
        case OperationType.setShard:
          await controller.sendSetShardResponse(response);
          break;
        case OperationType.getShard:
          await controller.sendGetShardResponse(response);
          break;
        case OperationType.takeOwnership:
          await controller.sendTakeOwnershipResponse(response);
          break;
      }
      if (mounted) Navigator.of(context).pop();
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
