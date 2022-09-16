import 'base_controller.dart';

class PageController extends BaseController {
  late int pagesCount;
  int currentPage = 0;

  PageController({required super.diContainer, required this.pagesCount});

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
