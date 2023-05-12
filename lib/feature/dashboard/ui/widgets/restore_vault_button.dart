import 'package:guardian_keyper/app/routes.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

class RestoreVaultButton extends StatelessWidget {
  const RestoreVaultButton({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(routeVaultRestore),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            color: clIndigo500,
          ),
          padding: paddingAll8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recovery',
                    style: textStyleSourceSansPro612,
                  ),
                  Text(
                    'Restore a Vault',
                    style: textStylePoppins616,
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_outlined),
            ],
          ),
        ),
      );
}
