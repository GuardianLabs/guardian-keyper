import 'package:flutter/widgets.dart';

class PageControllerBase extends ChangeNotifier {
  final List<Widget> pages;

  int currentPage;

  PageControllerBase({required this.pages, this.currentPage = 0});

  void gotoScreen<T extends Widget>([int? pageNumber]) {
    currentPage = pageNumber ?? pages.indexWhere((e) => e is T);
    notifyListeners();
  }

  void nextScreen([void _]) {
    if (currentPage < pages.length - 1) {
      currentPage++;
      notifyListeners();
    }
  }

  void previousScreen([void _]) {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }
}
