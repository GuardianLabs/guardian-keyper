import 'package:flutter/material.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';
import '/src/core/model/core_model.dart';

class GuardianTileWidget extends StatelessWidget {
  final GuardianModel guardian;
  final bool? isOnline;
  final bool? isSuccess;
  final bool isWaiting;

  const GuardianTileWidget({
    super.key,
    required this.guardian,
    this.isOnline,
    this.isSuccess,
    this.isWaiting = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                  color: theme.colorScheme.onSecondary,
                  bgColor: isSuccess == null
                      ? null
                      : isSuccess == true
                          ? clGreen
                          : clRed,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Visibility(
                    visible: isOnline != null,
                    child: isOnline == true
                        ? Text(
                            'Online',
                            style: textStyleSourceSansPro412.copyWith(
                                color: clGreen),
                          )
                        : Text(
                            'Offline',
                            style: textStyleSourceSansPro412.copyWith(
                                color: clRed),
                          ),
                  ),
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
                if (guardian.tag.isNotEmpty)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: theme.colorScheme.secondary,
                    ),
                    child: Text(
                      '   ${guardian.tag}   ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textStyleSourceSansPro412Purple,
                    ),
                  ),
                // Title
                Text(
                  guardian.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyleSourceSansPro614.copyWith(
                    color: guardian.peerId.value.isEmpty
                        ? clRed
                        : theme.colorScheme.primary,
                    height: 1.5,
                  ),
                ),
                // Subtitle
                Text(
                  guardian.peerId.toHexShort(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
}
