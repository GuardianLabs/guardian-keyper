import 'package:flutter/material.dart';

import '../core/widgets/common.dart';
import '../core/widgets/icon_of.dart';
import '../guardian/guardian_view.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: ListTile(
                  title: const Text('Show QR code'),
                  trailing: const IconOf.app(),
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      alignment: Alignment.center,
                      backgroundColor: Colors.white,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Do not close until pairing finish!'),
                      content: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        child: const GuardianView(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: Navigator.of(context).pop,
                          child: const Text('close'),
                        ),
                      ],
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
