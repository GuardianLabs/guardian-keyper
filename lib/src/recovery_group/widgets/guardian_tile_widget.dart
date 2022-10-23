import 'package:flutter/material.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';
import 'online_status_widget.dart';

class GuardianTileWidget extends StatelessWidget {
  final PeerId guardian;
  final String tag; //TBD: remove
  final bool? isSuccess;
  final bool isWaiting;
  final bool checkStatus;

  const GuardianTileWidget({
    super.key,
    required this.guardian,
    this.tag = '',
    this.isSuccess,
    this.isWaiting = false,
    this.checkStatus = false,
  });

  @override
  Widget build(BuildContext context) => Container(
        decoration: boxDecoration,
        padding: paddingV12,
        child: Row(
          children: [
            // Leading
            Padding(
              padding: paddingH20,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconOf.shield(
                    color: Theme.of(context).colorScheme.onSecondary,
                    bgColor: isSuccess == null
                        ? null
                        : isSuccess == true
                            ? clGreen
                            : clRed,
                  ),
                  if (checkStatus)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: OnlineStatusWidget(peerId: guardian),
                    ),
                ],
              ),
            ),
            // Body
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag
                  if (tag.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: borderRadius,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Text(
                        '   $tag   ',
                        maxLines: 1,
                        style: textStyleSourceSansPro412Purple,
                      ),
                    ),
                  // Title
                  Text(
                    guardian.nameEmoji,
                    maxLines: 1,
                    style: textStyleSourceSansPro614.copyWith(
                      color: guardian.token.isEmpty
                          ? clRed
                          : Theme.of(context).colorScheme.primary,
                      height: 1.5,
                    ),
                  ),
                  // Subtitle
                  Text(
                    guardian.toHexShort(),
                    maxLines: 1,
                    style: textStyleSourceSansPro414Purple,
                  ),
                ],
              ),
            ),
            // Trailing
            Padding(
              padding: paddingH20,
              child: SizedBox(
                height: 20,
                width: 20,
                child: isWaiting
                    ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
                    : null,
              ),
            ),
          ],
        ),
      );
}
