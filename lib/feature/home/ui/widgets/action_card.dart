import 'package:guardian_keyper/ui/widgets/common.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Leading Icon
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: icon,
                  ),
                  // Title
                  Text(
                    title,
                    maxLines: 1,
                    style: theme.textTheme.titleLarge,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                // Subtitle
                child: Text(
                  subtitle,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
