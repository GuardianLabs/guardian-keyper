import 'package:flutter/widgets.dart';

import '/src/core/di_container.dart';

class PageControllerBase extends ChangeNotifier {
  final diContainer = GetIt.I<DIContainer>();
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
