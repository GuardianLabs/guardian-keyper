import 'common.dart';
import '../presenters/page_presenter_base.dart';

export '../presenters/page_presenter_base.dart';

typedef PopInvokeWithResult = void Function(bool didPop, Object? result);

class StepperScreen<T extends PagePresentererBase?> extends StatelessWidget {
  const StepperScreen({
    required this.pages,
    required this.create,
    this.minimumPadding = const EdgeInsets.all(16),
    this.physics = const NeverScrollableScrollPhysics(),
    this.onPopInvokedWithResult,
    super.key,
  });

  final Create<T> create;
  final List<Widget> pages;
  final ScrollPhysics physics;
  final PopInvokeWithResult? onPopInvokedWithResult;
  final EdgeInsets minimumPadding;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: onPopInvokedWithResult == null,
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: ScaffoldSafe(
          minimumPadding: minimumPadding,
          child: ChangeNotifierProvider(
            lazy: false,
            create: create,
            builder: (context, _) => PageView(
              controller: context.read<T>(),
              physics: physics,
              children: pages,
            ),
          ),
        ),
      );
}
