import 'package:flutter/foundation.dart';

mixin PagesController on ChangeNotifier {
  late int pagesCount;
  int currentPage = 0;

  void gotoScreen(int value) {
    if (value < 0 || value > pagesCount - 1) return;
    currentPage = value;
    notifyListeners();
  }

  void nextScreen() {
    if (currentPage < pagesCount - 1) {
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
