import '../../domain/message_model.dart';

mixin MessageTitlesMixin {
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

  String getTitle(final MessageModel message) => _titles[message.code] ?? '';

  String getSubtitle(final MessageModel message) =>
      _subtitles[message.code] ?? '';
}
