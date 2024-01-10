import 'package:guardian_keyper/ui/widgets/common.dart';

class AllDonePage extends StatelessWidget {
  const AllDonePage({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
  });

  final Widget icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.background,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageTitle(
              icon: icon,
              title: title,
              subtitle: subtitle,
            ),
            FilledButton(
              onPressed: Navigator.of(context).pop,
              child: const Text('Great'),
            ),
          ],
        ),
      );
}
