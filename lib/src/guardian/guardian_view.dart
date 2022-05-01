import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/icon_of.dart';

import 'guardian_controller.dart';
import 'pages/secret_shard_page.dart';

class GuardianView extends StatelessWidget {
  const GuardianView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<GuardianController>(context);
    final shards = controller.secretShards;
    return shards.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: paddingV20,
                child: IconOf.secrets(radius: 40, size: 40),
              ),
              RichText(
                textAlign: TextAlign.center,
                softWrap: true,
                overflow: TextOverflow.clip,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'You don`t have any\n',
                      style: textStylePoppinsBold20,
                    ),
                    TextSpan(
                      text: 'secrets stored',
                      style: textStylePoppinsBold20Blue,
                    ),
                  ],
                ),
              ),
            ],
          )
        : ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              for (final shard in shards)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 1),
                  child: ListTile(
                    dense: true,
                    leading: IconOf.shield(
                      radius: 18,
                      size: 20,
                      bgColor: Theme.of(context).colorScheme.onPrimary,
                    ),
                    title: Text(shard.groupName, style: textStylePoppinsBold16),
                    subtitle: RichText(
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.clip,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Owner: ',
                            style: textStyleSourceSansProRegular14.copyWith(
                                color: clPurpleLight),
                          ),
                          TextSpan(
                            text: shard.ownerName,
                            style: textStyleSourceSansProBold14,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SecretShardPage(secretShard: shard))),
                  ),
                )
            ],
          );
  }
}
