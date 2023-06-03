import 'package:flutter/widgets.dart';

abstract class PagePresenterBase extends ChangeNotifier {
  final int pageCount;

  int currentPage;

  PagePresenterBase({
    required this.pageCount,
    this.currentPage = 0,
  });

  void gotoPage(int pageNumber) {
    currentPage = pageNumber;
    notifyListeners();
  }

  void nextPage([void _]) {
    if (currentPage < pageCount - 1) {
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
