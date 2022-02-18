import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PackageInfo.fromPlatform(),
      builder: ((context, AsyncSnapshot<PackageInfo?> snapshot) =>
          Text('${snapshot.data?.version}+${snapshot.data?.buildNumber}')),
    );
  }
}
