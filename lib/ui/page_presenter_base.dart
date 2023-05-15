import 'package:flutter/widgets.dart';

abstract class PagePresenterBase extends ChangeNotifier {
  final List<Widget> pages;

  int currentPage;

  PagePresenterBase({
    required this.pages,
    this.currentPage = 0,
  });

  void gotoPage(int pageNumber) {
    currentPage = pageNumber;
    notifyListeners();
  }

  void nextPage([void _]) {
    if (currentPage < pages.length - 1) {
      currentPage++;
      notifyListeners();
    }
  }

  void previousPage([void _]) {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }
}
