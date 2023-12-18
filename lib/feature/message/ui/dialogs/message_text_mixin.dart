import 'package:intl/intl.dart';

import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';

mixin class MessageTextMixin {
  static const _titles = {
    MessageCode.createVault: 'Guardian Approval Request',
    MessageCode.setShard: 'Accept the Secret Shard',
    MessageCode.getShard: 'Secret Recovery Request',
    MessageCode.takeVault: 'Ownership Change Request',
  };

  static const _subtitles = {
    MessageCode.createVault: ' asks you to become a Vault Guardian for ',
    MessageCode.setShard: ' asks you to accept the Secret Shard for ',
    MessageCode.getShard: ' asks you to approve a recovery of Secret for ',
    MessageCode.takeVault: ' asks you to approve a change of ownership for ',
  };

  static final yamd = DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY);
  static final h24ms = DateFormat(DateFormat.HOUR24_MINUTE_SECOND);

  String getTitle(MessageModel message) => _titles[message.code]!;

  String getSubtitle(MessageModel message) => _subtitles[message.code]!;

  String roundedAgo(MessageModel message) {
    const hoursInMonth = 24 * 30;
    const hoursInYear = 24 * 30 * 365;
    final diff = DateTime.timestamp().difference(message.timestamp);
    if (diff.inMinutes == 0) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inHours < hoursInMonth) return '${diff.inHours ~/ 24}d ago';
    return diff.inHours < hoursInYear
        ? '${diff.inHours ~/ hoursInMonth} month ago'
        : '${diff.inHours ~/ hoursInYear} year ago';
  }
}
