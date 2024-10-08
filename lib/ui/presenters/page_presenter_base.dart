import 'package:flutter/widgets.dart';

import 'package:guardian_keyper/consts.dart';

export 'package:provider/provider.dart';

class PagePresentererBase extends PageController {
  PagePresentererBase({
    required this.stepsCount,
    super.initialPage = 0,
    super.keepPage = false,
  });

  final int stepsCount;

  late int _currentPage = super.initialPage;

  int get currentPage => _currentPage;

  @override
  Future<void> nextPage({Curve? curve, Duration? duration}) {
    _currentPage++;
    return super.nextPage(
      duration: duration ?? kPageChangeDuration,
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  Future<void> previousPage({Curve? curve, Duration? duration}) {
    if (_currentPage > 0) _currentPage--;
    return super.previousPage(
      duration: duration ?? kPageChangeDuration,
      curve: curve ?? Curves.easeInOut,
    );
  }

  @override
  void jumpToPage(int page) {
    if (page >= 0) _currentPage = page;
    super.jumpToPage(page);
  }
}
