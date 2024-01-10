import 'page_presenter_base.dart';

export 'package:provider/provider.dart';

class HomeTabPresenter extends PagePresentererBase {
  HomeTabPresenter({
    required super.stepsCount,
    super.keepPage = true,
    super.initialPage,
  });
}
