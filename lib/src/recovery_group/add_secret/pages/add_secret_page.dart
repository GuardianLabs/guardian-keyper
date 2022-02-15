import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import '../../../core/theme_data.dart';
import '../../../core/widgets/common.dart';
// import '../../../core/widgets/icon_of.dart';

import '../add_secret_controller.dart';

class AddSecretPage extends StatefulWidget {
  const AddSecretPage({Key? key}) : super(key: key);

  @override
  State<AddSecretPage> createState() => _AddSecretPageState();
}

class _AddSecretPageState extends State<AddSecretPage> {
  bool _isSecretObscure = true;
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddSecretController>(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            // Header
            const HeaderBar(
              title: Padding(
                padding: EdgeInsets.only(top: 55),
                child: Text('Add secret'),
              ),
              backButton: HeaderBarBackButton(),
              // backButton: HeaderBarBackButton(onPressed: state.previousScreen),
              // closeButton: HeaderBarCloseButton(),
            ),
            // Body
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: Icon(Icons.key_outlined, size: 40),
            ),
            const Text('Add your secret', textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextField(
                controller: _ctrl,
                keyboardType: TextInputType.name,
                obscureText: _isSecretObscure,
                onChanged: (value) => setState(() => state.secret = value),
                decoration: InputDecoration(
                  border: Theme.of(context).inputDecorationTheme.border,
                  filled: Theme.of(context).inputDecorationTheme.filled,
                  fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                  labelText: 'YOUR SECRET',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  suffix: _ctrl.text.isEmpty || state.secret.isEmpty
                      ? TextButton(
                          child: const Text('Paste'),
                          onPressed: () async {
                            final cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            if (cdata != null && cdata.text != null) {
                              // _ctrl.text = cdata.text!;
                              setState(() {
                                _ctrl.text = cdata.text!;
                                state.secret = cdata.text!;
                              });
                            }
                          },
                        )
                      : _isSecretObscure
                          ? TextButton(
                              child: const Text('Show'),
                              onPressed: () => setState(
                                  () => _isSecretObscure = !_isSecretObscure),
                            )
                          : null,
                ),
              ),
            ),
            Expanded(child: Container()),
            // Footer
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: FooterButton(
                  text: 'Continue',
                  onPressed: state.secret.isEmpty
                      ? () {}
                      : () {
                          state.secret = _ctrl.text;
                          state.nextScreen();
                        }),
            ),
            Container(height: 50),
          ],
        ));
  }
}
