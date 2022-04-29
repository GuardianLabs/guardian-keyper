import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

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
    final isEmpty = _ctrl.text.isEmpty || state.secret.isEmpty;
    return Column(
      children: [
        // Header
        HeaderBar(
          title: HeaderBarTitleWithSubtitle(
            title: 'Recovery Group',
            subtitle: state.groupName,
          ),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
            child: ListView(
          primary: true,
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40, bottom: 10),
              child: IconOf.secret(radius: 40, size: 40),
            ),
            Padding(
              padding: paddingAll20,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Add your ', style: textStylePoppinsBold20),
                    TextSpan(text: 'secret', style: textStylePoppinsBold20Blue),
                  ],
                ),
              ),
            ),
            Padding(
              padding: paddingAll20,
              child: TextField(
                controller: _ctrl,
                keyboardType: TextInputType.name,
                obscureText: _isSecretObscure,
                maxLines: _isSecretObscure ? 1 : 10,
                minLines: 1,
                style: textStyleSourceSansProRegular16,
                onChanged: (value) => setState(() => state.secret = value),
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: 'YOUR SECRET',
                  counterText: '${_ctrl.text.length} symbols',
                  counterStyle: textStyleSourceSansProRegular14.copyWith(
                      color: clPurpleLight),
                  suffix: isEmpty
                      ? ElevatedButton(
                          child: Text('Paste', style: textStylePoppinsBold12),
                          onPressed: () async {
                            final cdata =
                                await Clipboard.getData(Clipboard.kTextPlain);
                            if (cdata != null && cdata.text != null) {
                              setState(() {
                                _ctrl.text = cdata.text!;
                                state.secret = cdata.text!;
                              });
                            }
                          },
                        )
                      : _isSecretObscure
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: clBlue),
                                shape: BoxShape.circle,
                              ),
                              height: 40,
                              child: IconButton(
                                color: clWhite,
                                icon: const Icon(Icons.visibility_outlined),
                                onPressed: () => setState(
                                    () => _isSecretObscure = !_isSecretObscure),
                              ),
                            )
                          : Container(
                              decoration: const BoxDecoration(
                                color: clBlue,
                                shape: BoxShape.circle,
                              ),
                              height: 40,
                              child: IconButton(
                                color: clWhite,
                                icon: const Icon(Icons.visibility_off_outlined),
                                onPressed: () => setState(
                                    () => _isSecretObscure = !_isSecretObscure),
                              ),
                            ),
                ),
              ),
            ),
            Padding(
                padding: paddingAll20,
                child: isEmpty
                    ? const InfoPanel.warning(
                        text: 'Make sure no one can see your screen.')
                    : const InfoPanel.info(
                        text:
                            'After sharding (splitting) the secret, shards will be encrypted and shared among your Guardians and erased from your device.')),
          ],
        )),
        // Footer
        Padding(
          padding: paddingFooter,
          child: PrimaryButtonBig(
              text: 'Continue',
              onPressed: state.secret.isEmpty
                  ? () {}
                  : () {
                      state.secret = _ctrl.text;
                      state.nextScreen();
                    }),
        ),
      ],
    );
  }
}
