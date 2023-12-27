import 'package:flutter/widgets.dart';

base class PagePresenterBase extends ChangeNotifier {
  final int pageCount;

  int currentPage;

  PagePresenterBase({
    required this.pageCount,
    this.currentPage = 0,
  });

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
