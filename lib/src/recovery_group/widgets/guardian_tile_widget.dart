import 'package:flutter/material.dart';

import '/src/core/utils.dart';
import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';

import '../recovery_group_model.dart';

class GuardianTileWidget extends StatelessWidget {
  final RecoveryGroupGuardianModel guardian;
  final bool isWaiting;
  final bool isHighlighted;

  const GuardianTileWidget({
    Key? key,
    required this.guardian,
    this.isWaiting = false,
    this.isHighlighted = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      dense: true,
      iconColor:
          guardian.pubKey.data.isEmpty ? theme.colorScheme.onPrimary : clGreen,
      leading: IconOf.shield(
        radius: 18,
        size: 20,
        bgColor: isHighlighted ? clGreen : theme.colorScheme.onPrimary,
      ),
      title: Row(
        children: [
          Text(
            guardian.name,
            maxLines: 1,
            style: textStylePoppinsBold16.copyWith(
              color: guardian.pubKey.data.isEmpty
                  ? clRed
                  : theme.colorScheme.primary,
            ),
          ),
          if (guardian.tag.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: theme.colorScheme.secondary,
                ),
                child: Text(
                  '   ${guardian.tag}   ',
                  style: textStyleSourceSansProRegular14.copyWith(
                      color: clPurpleLight),
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        toHexShort(guardian.pubKey.data),
        maxLines: 1,
        style: textStyleSourceSansProBold14.copyWith(
          color: clPurpleLight,
          height: 1.5,
        ),
      ),
      trailing: SizedBox(
        height: 20,
        width: 20,
        child: isWaiting
            ? const CircularProgressIndicator.adaptive(strokeWidth: 2)
            : null,
      ),
    );
  }
}
