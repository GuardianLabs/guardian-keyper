import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme_data.dart';
import '../core/widgets/icon_of.dart';

import 'guardian_controller.dart';
import 'pages/secret_shard_page.dart';

class GuardianView extends StatelessWidget {
  const GuardianView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shards = Provider.of<GuardianController>(context).secretShards;
    return shards.isEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: IconOf.group(radius: 40),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('You don`t have any secrets stored'),
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
                    tileColor: clIndigo700,
                    title: Text(shard.groupName),
                    subtitle: Text('Owner: ${shard.ownerName}'),
                    leading: const IconOf.app(),
                    trailing:
                        Text('${shard.groupSize}/${shard.groupThreshold}'),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => SecretShardPage(secretShard: shard))),
                  ),
                )
            ],
          );
  }
}
