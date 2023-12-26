import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

class CurrentRouteObserver extends RouteObserver<ModalRoute<dynamic>> {
  String? _currentRouteName;

  String? get currentRouteName => _currentRouteName;

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _currentRouteName = newRoute?.settings.name;
    if (kDebugMode) print('Current route name: $_currentRouteName');
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = route.settings.name;
    if (kDebugMode) print('Current route name: $_currentRouteName');
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = previousRoute?.settings.name;
    if (kDebugMode) print('Current route name: $_currentRouteName');
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _currentRouteName = previousRoute?.settings.name;
    if (kDebugMode) print('Current route name: $_currentRouteName');
    super.didRemove(route, previousRoute);
  }
}
