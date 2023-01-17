part of 'network_service.dart';

mixin ConnectivityHandler on NetworkServiceBase {
  final _connectivity = Connectivity();
  final _connectivityController = StreamController<bool>.broadcast();

  ConnectivityResult _connectivityType = ConnectivityResult.none;

  bool get hasConnectivity =>
      _connectivityType == ConnectivityResult.wifi ||
      _connectivityType == ConnectivityResult.mobile;

  Stream<bool> get connectivityStream => _connectivityController.stream;

  Future<void> _connectivityInit() async {
    _connectivityType = await _connectivity.checkConnectivity();
    _connectivity.onConnectivityChanged.listen((result) {
      _connectivityType = result;
      _connectivityController.add(result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile);
    });
  }
}

mixin MdnsHandler on NetworkServiceBase {
  final _mdnsType = '_dartshare._udp';
  final _mdnsPeerId = 'peer_id';
  final _mdnsName = 'Guardian Keyper';

  late final BonsoirService _mdnsService;
  BonsoirDiscovery? _mdnsDiscovery;
  BonsoirBroadcast? _mdnsBroadcast;
  StreamSubscription<BonsoirDiscoveryEvent>? _mdnsSubscription;

  void _mdnsInit(int port, String peerId) {
    _mdnsService = BonsoirService(
      name: _mdnsName,
      type: _mdnsType,
      port: port,
      attributes: {_mdnsPeerId: peerId},
    );
  }

  Future<void> startMdnsBroadcast() async {
    if (_mdnsBroadcast == null || _mdnsBroadcast!.isStopped) {
      _mdnsBroadcast = BonsoirBroadcast(service: _mdnsService);
    }
    await _mdnsBroadcast!.ready;
    await _mdnsBroadcast!.start();
  }

  Future<void> stopMdnsBroadcast() async {
    await _mdnsBroadcast?.stop();
    _mdnsBroadcast = null;
  }

  Future<void> startMdnsDiscovery() async {
    if (_mdnsDiscovery == null || _mdnsDiscovery!.isStopped) {
      _mdnsDiscovery = BonsoirDiscovery(type: _mdnsType);
    }
    await _mdnsDiscovery!.ready;
    _mdnsSubscription = _mdnsDiscovery!.eventStream!.listen(_onMdnsEvent);
    await _mdnsDiscovery!.start();
  }

  Future<void> stopMdnsDiscovery() async {
    await _mdnsSubscription?.cancel();
    await _mdnsDiscovery?.stop();
    _mdnsSubscription = null;
    _mdnsDiscovery = null;
  }

  void _onMdnsEvent(BonsoirDiscoveryEvent event) {
    if (event.type == BonsoirDiscoveryEventType.discoveryServiceResolved) {
      final eventMap = event.service?.toJson();
      if (eventMap == null) return;
      if (eventMap['service.type'] != _mdnsType) return;
      if (eventMap['service.name'] != _mdnsName) return;
      final peerId = P2PPeerId(
        value: base64Decode(eventMap['service.attributes']?[_mdnsPeerId]),
      );
      if (peerId == router.selfId) return;
      router.addPeerAddress(
        peerId: peerId,
        addresses: [
          P2PFullAddress(
            address: InternetAddress(eventMap['service.ip']),
            port: event.service!.port,
          ),
        ],
      );
    }
  }
}
