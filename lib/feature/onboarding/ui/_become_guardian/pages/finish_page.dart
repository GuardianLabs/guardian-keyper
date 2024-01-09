import 'package:guardian_keyper/ui/widgets/common.dart';

class FinishPage extends StatelessWidget {
  const FinishPage({super.key});

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageTitle(
            icon: Icon(Icons.shield_outlined, size: 110),
            title: 'You are a Guardian!',
            subtitle: 'Now you can store encrypted parts of entrusted '
                'Secrets and create your own.',
          ),
          FilledButton(
            onPressed: Navigator.of(context).pop,
            child: const Text('Great'),
          ),
        ],
      );
}
