import 'base_controller.dart';

class PageController extends BaseController {
  final int pagesCount;
  int currentPage;

  PageController({
    required super.diContainer,
    required this.pagesCount,
    this.currentPage = 0,
  });

  void gotoScreen(int value) {
    if (value < 0 || value > pagesCount - 1) return;
    currentPage = value;
    notifyListeners();
  }

  void nextScreen([void _]) {
    if (currentPage < pagesCount - 1) {
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
