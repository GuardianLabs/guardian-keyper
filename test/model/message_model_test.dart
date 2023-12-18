import 'package:flutter_test/flutter_test.dart';
import 'package:guardian_keyper/domain/entity/id_base.dart';
import 'package:guardian_keyper/feature/message/domain/entity/message_model.dart';
import 'package:guardian_keyper/feature/network/domain/entity/peer_id.dart';
import '../data/filled_models.dart';

void main() {
  group('==', () {
    final m = MessageModel(
      id: requestIdA,
      peerId: peerIdA,
      timestamp: now,
      code: MessageCode.getShard,
      payload: secretShardA,
    );

    final mTheSameId = MessageModel(
      id: requestIdA,
      peerId: peerIdB,
      timestamp: now.add(const Duration(seconds: 1)),
      code: MessageCode.setShard,
      payload: secretShardB,
    );

    final mTheSameExceptId = MessageModel(
      id: requestIdB,
      peerId: peerIdA,
      timestamp: now,
      code: MessageCode.getShard,
      payload: secretShardA,
    );

    test(
      'everything is different except id, should be true',
      () => expect(
        m == mTheSameId,
        true,
      ),
    );
    test(
      'everything is equal except id, should be false',
      () => expect(
        m == mTheSameExceptId,
        false,
      ),
    );
  });

  group(
    'hashCode',
    () {
      final tokenA = PeerId(token: IdBase.getNewToken(length: 64));
      final tokenB = PeerId(token: IdBase.getNewToken(length: 64));
      final tokenC = PeerId(token: IdBase.getNewToken(length: 64));
      final s = {tokenA, tokenB};

      test(
          'should be true',
          () => expect(
                s.containsAll({tokenA, tokenB}),
                true,
              ));
      test(
          'should be false',
          () => expect(
                s.containsAll({tokenA, tokenB, tokenC}),
                false,
              ));
    },
  );

  test('MessageStatus, tests for hasResponse and isForPrune', () {
    final peerId = PeerId(token: IdBase.getNewToken(length: 64));
    final hasExpired =
        now.subtract(MessageModel.requestExpires + const Duration(seconds: 1));

    for (final i in MessageStatus.values) {
      final m = MessageModel(
        peerId: peerId,
        code: MessageCode.createVault,
        status: i,
        timestamp: now,
      );

      final mExpired = MessageModel(
        peerId: peerId,
        code: MessageCode.createVault,
        status: i,
        timestamp: hasExpired,
      );

      if (m.status == MessageStatus.created ||
          m.status == MessageStatus.received) {
        expect(m.hasResponse, false);
        expect(m.isForPrune, false);
        expect(mExpired.isForPrune, true);
      } else {
        expect(m.hasResponse, true);
        expect(m.isForPrune, false);
        expect(mExpired.isForPrune, false);
      }
    }
  });

  test(
    'Message generation: should not be equal',
    () => () => expect(
          p2pPacketA == p2pPacketB,
          false,
        ),
  );

  group('toBytes/fromBytes', () {
    test(
      'toBytes/fromBytes 1, should be equal',
      () => expect(MessageModel.fromBytes(p2pPacketA.toBytes()), p2pPacketA),
    );
    test(
      'toBytes/fromBytes 2, should be equal',
      () => expect(MessageModel.fromBytes(p2pPacketB.toBytes()), p2pPacketB),
    );
    test(
      'toBytes/fromBytes 3, should be false',
      () => expect(
        MessageModel.fromBytes(p2pPacketA.toBytes()) == p2pPacketB,
        false,
      ),
    );
  });
}
