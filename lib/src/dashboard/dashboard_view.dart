import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../core/utils.dart';
// import '../core/theme_data.dart';
import '../core/widgets/common.dart';
import '../core/widgets/icon_of.dart';

// import '../recovery_group/recovery_group_view.dart';
// import '../recovery_group/create_group/create_group_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderBar(title: HeaderBarTitleLogo()),
        Expanded(
          child: ListView(
            restorationId: 'homeListView',
            padding: const EdgeInsets.all(20),
            children: [
              Padding(
                padding: _paddingV5,
                child: ListTile(
                  title: const Text('Show QR code'),
                  trailing: const IconOf.app(),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.center,
                      backgroundColor: Colors.white,
                      content: SizedBox(
                        height: 200,
                        width: 200,
                        child: QrImage(data: getRandomString()),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
