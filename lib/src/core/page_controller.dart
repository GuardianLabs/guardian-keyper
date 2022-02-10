import 'package:flutter/foundation.dart';

mixin PagesController on ChangeNotifier {
  late int lastScreen;
  int currentScreen = 0;

  void gotoScreen(int value) {
    if (value < 0 || value > lastScreen) return;
    currentScreen = value;
    notifyListeners();
  }

  void nextScreen() {
    if (currentScreen < lastScreen) {
      currentScreen++;
      notifyListeners();
    }
  }

  void previousScreen() {
    if (currentScreen > 0) {
      currentScreen--;
      notifyListeners();
    }
  }
}
