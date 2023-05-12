import 'page_presenter_base.dart';

export 'package:provider/provider.dart';

class HomePresenter extends PagePresenterBase {
  HomePresenter({
    required super.pages,
    required this.vaultsPageNum,
    required this.shardsPageNum,
  });

  final int vaultsPageNum, shardsPageNum;

  void gotoVaults() => gotoPage(vaultsPageNum);

  void gotoShards() => gotoPage(shardsPageNum);
}
