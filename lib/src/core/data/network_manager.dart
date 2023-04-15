import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:p2plib/p2plib.dart' as p2p;
import 'package:nsd/nsd.dart';

import '../app/consts.dart';
import '/src/core/data/core_model.dart';
import '/src/core/infrastructure/secure_storage.dart';

// TBD: update transports with NetworkInterface.list()
class NetworkManager with ConnectivityHandler, MdnsHandler {
  static const _initLimit = Duration(seconds: 5);

  NetworkManager({final SecureStorage? secureStorage})
      : _secureStorage =
            secureStorage ?? SecureStorage(storage: Storages.settings),
        _router = p2p.RouterL2(
          logger: kDebugMode ? print : null,
          keepalivePeriod: keepalivePeriod,
        )
          ..maxForwardsLimit = maxForwardsLimit
          ..maxStoredHeaders = maxStoredHeaders;

  @override
  int get defaultPort => p2p.TransportUdp.defaultPort;

  Duration get messageTTL => _router.messageTTL;

  PeerId get myPeerId => PeerId(token: _router.selfId.value);

  Stream<MessageModel> get messageStream => _messagesController.stream;

  Stream<MapEntry<PeerId, bool>> get peerStatusChangeStream =>
      _router.lastSeenStream
          .map((e) => MapEntry(PeerId(token: e.key.value), e.value));

  @override
  final p2p.RouterL2 _router;

  final SecureStorage _secureStorage;

  final _messagesController = StreamController<MessageModel>.broadcast();

  p2p.Route? _bsServer;

  /// Return 32byte seed
  Future<Uint8List> init() async {
    final seed = await _secureStorage.get<Uint8List>(keySeed) ?? Uint8List(0);
    final cryptoKeys = await _router
        .init(p2p.CryptoKeys.empty()..seed = seed)
        .timeout(_initLimit);
    if (seed.isEmpty) {
      await _secureStorage.set<Uint8List>(keySeed, cryptoKeys.seed);
    }
    _router.messageStream.listen(onMessage);
    await _connectivityInit().timeout(_initLimit);
    await _initMdns().timeout(_initLimit);
    if (kDebugMode) print(_router.selfId);
    if (await _secureStorage.get(keyIsBootstrapEnabled) ?? false) {
      addBootstrapServer(
        Envs.bsPeerId,
        port: Envs.bsPort,
        ipV4: Envs.bsAddressV4,
        ipV6: Envs.bsAddressV6,
      );
    }
    return cryptoKeys.seed;
  }

  Future<void> start([void _]) async {
    _connectivityType = await _connectivity.checkConnectivity();
    if (kDebugMode) print(_connectivityType);
    if (_connectivityType == ConnectivityResult.none) return;
    await _startMdns();
    await _router.start();
    if (_bsServer != null) {
      _router.sendMessage(
        dstPeerId: _bsServer!.peerId,
        useAddresses: _bsServer!.addresses.keys,
      );
    }
  }

  Future<void> pause([void _]) async {
    _router.stop();
    await _pauseMdns();
  }

  Future<void> stop([void _]) async {
    _router.stop();
    await _stopMdns();
  }

  void onMessage(final p2p.Message p2pMessage) {
    final message = MessageModel.tryFromBytes(p2pMessage.payload);
    if (message == null) return;
    if (message.version != MessageModel.currentVersion) return;
    _messagesController.add(message);
  }

  bool getPeerStatus(final PeerId peerId) =>
      _router.getPeerStatus(p2p.PeerId(value: peerId.token));

  Future<bool> pingPeer(final PeerId peerId) =>
      _router.pingPeer(p2p.PeerId(value: peerId.token));

  Future<void> sendTo({
    required final PeerId peerId,
    required final MessageModel message,
    required final bool isConfirmable,
  }) async {
    try {
      await _router.sendMessage(
        isConfirmable: isConfirmable,
        dstPeerId: p2p.PeerId(value: peerId.token),
        payload: message.toBytes(),
      );
    } catch (_) {
      if (isConfirmable) rethrow;
    }
  }

  void removeBootstrapServer(final String peerId) =>
      _router.removePeerAddress(p2p.PeerId(value: base64Decode(peerId)));

  void addBootstrapServer(
    final String peerId, {
    final String ipV4 = '',
    final String ipV6 = '',
    final int? port,
  }) async {
    final bsPeerId = p2p.PeerId(value: base64Decode(peerId));
    _bsServer = p2p.Route(
      peerId: bsPeerId,
      canForward: true,
      addresses: {
        p2p.FullAddress(
          address: InternetAddress(ipV4),
          port: port ?? defaultPort,
        ): p2p.AddressProperties(isStatic: true),
        p2p.FullAddress(
          address: InternetAddress(ipV6),
          port: port ?? defaultPort,
        ): p2p.AddressProperties(isStatic: true),
      },
    );
    _router.routes[bsPeerId] = _bsServer!;
    if (kDebugMode) {
      print('See ${_router.routes.length} existing routes');
      print('Bootstrap addresses: ${_router.routes[bsPeerId]?.addresses}');
    }
    if (_router.isRun) _router.sendMessage(dstPeerId: bsPeerId);
  }
}

// TBD: separate to independent repository
mixin ConnectivityHandler {
  final _connectivity = Connectivity();
  final _connectivityController = StreamController<bool>.broadcast();

  late ConnectivityResult _connectivityType;

  bool get hasConnectivity => _connectivityType != ConnectivityResult.none;

  Future<bool> get checkConnectivity => _connectivity
      .checkConnectivity()
      .then((result) => result != ConnectivityResult.none);

  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<void> _connectivityInit() async {
    _connectivityType = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      if (kDebugMode) print(result);
      _connectivityType = result;
      _connectivityController.add(result != ConnectivityResult.none);
    });
  }
}

mixin MdnsHandler {
  static const _utf8Encoder = Utf8Encoder();
  static const _utf8Decoder = Utf8Decoder();

  p2p.RouterL2 get _router;

  int get defaultPort;

  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';

  late final Registration _registration;
  late final _service = Service(
    name: 'Guardian Keyper',
    type: _mdnsType,
    port: defaultPort,
    txt: {
      _mdnsPeerId: _utf8Encoder.convert(base64Encode(_router.selfId.value))
    },
  );

  Discovery? _discovery;

  Future<void> _initMdns() async {
    try {
      _registration = await register(_service).timeout(
        const Duration(seconds: 3),
      );
    } on NsdError catch (e) {
      if (kDebugMode) print(e);
    } on TimeoutException catch (e) {
      if (kDebugMode) print(e);
    }
  }

  Future<void> _startMdns() async {
    _discovery ??= await startDiscovery(
      _mdnsType,
      ipLookupType: IpLookupType.any,
    ).timeout(const Duration(seconds: 3))
      ..addServiceListener(_onEvent);
  }

  Future<void> _pauseMdns() async {
    if (_discovery == null) return;
    await stopDiscovery(_discovery!);
    _discovery?.dispose();
    _discovery = null;
  }

  Future<void> _stopMdns() async {
    await _pauseMdns();
    await unregister(_registration);
  }

  void _onEvent(Service service, ServiceStatus status) {
    if (kDebugMode) print('mDNS $status: ${service.addresses}');
    if (service.type != _mdnsType) return;
    final peerIdBytes = service.txt?[_mdnsPeerId];
    if (peerIdBytes == null) return;
    if (status == ServiceStatus.found) {
      for (final address in service.addresses!) {
        _router.addPeerAddress(
          peerId: p2p.PeerId(
            value: base64Decode(_utf8Decoder.convert(peerIdBytes)),
          ),
          address: p2p.FullAddress(address: address, port: service.port!),
          properties: p2p.AddressProperties(isStatic: true, isLocal: true),
        );
      }
    }
  }
}
