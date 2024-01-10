import 'common.dart';
import '../utils/page_controller_base.dart';

export '../utils/page_controller_base.dart';

typedef PopInvoke = void Function(bool);

class StepperScreen<T extends PageControllerBase?> extends StatelessWidget {
  const StepperScreen({
    required this.pages,
    required this.create,
    this.minimumPadding = const EdgeInsets.all(16),
    this.physics = const NeverScrollableScrollPhysics(),
    this.onPopInvoked,
    super.key,
  });

  final Create<T> create;
  final List<Widget> pages;
  final ScrollPhysics physics;
  final PopInvoke? onPopInvoked;
  final EdgeInsets minimumPadding;

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: onPopInvoked == null,
        onPopInvoked: onPopInvoked,
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
