import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';
import 'package:guardian_keyper/domain/entity/message_model.dart';

mixin MessageTitlesMixin {
  static const _icons = {
    MessageCode.createGroup: IconOf.shield(color: clWhite),
    MessageCode.setShard: IconOf.splitAndShare(),
    MessageCode.getShard: IconOf.secret(),
    MessageCode.takeGroup: IconOf.owner(),
  };

  static const _titles = {
    MessageCode.createGroup: 'Guardian Approval Request',
    MessageCode.setShard: 'Accept the Secret Shard',
    MessageCode.getShard: 'Secret Recovery Request',
    MessageCode.takeGroup: 'Ownership Change Request',
  };

  static const _subtitles = {
    MessageCode.createGroup: ' asks you to become a Guardian for ',
    MessageCode.setShard: ' asks you to accept the Secret Shard for ',
    MessageCode.getShard: ' asks you to approve a recovery of Secret for ',
    MessageCode.takeGroup: ' asks you to approve a change of ownership for ',
  };

  IconOf getIcon(final MessageModel message) => _icons[message.code]!;

  String getTitle(final MessageModel message) => _titles[message.code]!;

  String getSubtitle(final MessageModel message) => _subtitles[message.code]!;
}
