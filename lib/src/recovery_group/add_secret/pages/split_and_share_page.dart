import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
// import '../../../core/widgets/icon_of.dart';

import '../add_secret_controller.dart';
import '../../recovery_group_controller.dart';

class SplitAndShareSecretPage extends StatefulWidget {
  const SplitAndShareSecretPage({Key? key}) : super(key: key);

  @override
  State<SplitAndShareSecretPage> createState() =>
      _SplitAndShareSecretPageState();
}

class _SplitAndShareSecretPageState extends State<SplitAndShareSecretPage> {
  bool _isSecretObscure = true;

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddSecretController>(context);
    final controller = context.read<RecoveryGroupController>();
    final group = controller.groups[state.groupName]!;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              caption: 'Split And Share Secret',
              // backButton: HeaderBarBackButton(onPressed: state.previousScreen),
              closeButton: HeaderBarCloseButton(),
            ),
            // Body
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: Icon(Icons.key_outlined, size: 40),
            ),
            const Text(
                'The secret will be split and shared among the following Guardians',
                textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: TextEditingController(text: state.secret),
                obscureText: _isSecretObscure,
                readOnly: true,
                decoration: InputDecoration(
                  border: Theme.of(context).inputDecorationTheme.border,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'YOUR SECRET',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  isDense: true,
                  suffix: _isSecretObscure
                      ? TextButton(
                          child: const Text('Show'),
                          onPressed: () => setState(
                              () => _isSecretObscure = !_isSecretObscure),
                        )
                      : null,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  for (var guardian in group.guardians.values)
                    GuardianListTileWidget(
                      name: guardian.name,
                      code: guardian.pubKey.toString(),
                      tag: guardian.tag,
                      // nameColor: guardian.code.isEmpty ? clRed : clWhite,
                      iconColor: clIndigo500,
                      status: clYellow,
                    ),
                ],
              ),
            ),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(
                text: 'Split and Share Secret',
                onPressed: () {
                  // Future.delayed(
                  //   const Duration(milliseconds: 50),
                  //   state.nextScreen,
                  // );
                  state.nextScreen();
                  // controller.distributeShards(
                  //   group.guardians.values.map((v) => v.pubKey).toList(),
                  //   group.id,
                  //   state.secret,
                  // );
                },
              ),
            ),
            Container(height: 50),
          ],
        ));
  }
}
