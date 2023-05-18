import 'package:guardian_keyper/ui/presenters/page_presenter_base.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase {
  HomePresenter({required super.pageCount});

  void gotoVaults() => gotoPage(1);

  void gotoShards() => gotoPage(2);
}
