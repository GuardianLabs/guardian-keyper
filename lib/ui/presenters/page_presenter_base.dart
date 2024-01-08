import 'package:flutter/widgets.dart';

base class PagePresenterBase extends ChangeNotifier {
  PagePresenterBase({
    required int pageCount,
    int currentPage = 0,
  })  : _pageCount = pageCount,
        _currentPage = currentPage;

  final int _pageCount;

  int _currentPage;

  int get currentPage => _currentPage;

  int get pageCount => _pageCount;

  void nextPage([void _]) {
    if (_currentPage < _pageCount - 1) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage([void _]) {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }
}
