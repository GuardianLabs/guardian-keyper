part of 'network_service.dart';

// TBD: separate to independent repository
mixin ConnectivityHandler on NetworkServiceBase {
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
