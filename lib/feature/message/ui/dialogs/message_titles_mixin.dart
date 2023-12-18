import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../../domain/entity/message_model.dart';

mixin MessageTitlesMixin {
  static const _icons = {
    MessageCode.createVault: IconOf.shield(color: clWhite),
    MessageCode.setShard: IconOf.splitAndShare(),
    MessageCode.getShard: IconOf.secret(),
    MessageCode.takeVault: IconOf.owner(),
  };

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

  IconOf getIcon(MessageModel message) => _icons[message.code]!;

  String getTitle(MessageModel message) => _titles[message.code]!;

  String getSubtitle(MessageModel message) => _subtitles[message.code]!;
}
