import 'package:flutter/foundation.dart';

mixin PagesController on ChangeNotifier {
  late int lastPage;
  int currentPage = 0;

  void gotoScreen(int value) {
    if (value < 0 || value > lastPage) return;
    currentPage = value;
    notifyListeners();
  }

  void nextScreen() {
    if (currentPage < lastPage) {
      currentPage++;
      notifyListeners();
    }
  }

  void previousScreen() {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }
}
