import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';
import '/src/core/widgets/icon_of.dart';

import '../settings_controller.dart';

enum CurrentStep { enterCurrent, enterNew, enterNewAgain }

class PinCodePage extends StatefulWidget {
  const PinCodePage({Key? key}) : super(key: key);

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  static const _text = {
    CurrentStep.enterCurrent: 'Please enter your\ncurrent ',
    CurrentStep.enterNew: 'Please create your\nnew ',
    CurrentStep.enterNewAgain: 'Please repeat your\nnew ',
  };

  final _ctrl = TextEditingController();

  var _currentStep = CurrentStep.enterCurrent;
  var _currentCode = '';
  var _firstCode = '';
  var _secondCode = '';

  @override
  void initState() {
    super.initState();
    if (context.read<SettingsController>().pinCode.isEmpty) {
      _currentStep = CurrentStep.enterNew;
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<SettingsController>(context);
    final isSmall = MediaQuery.of(context).size.height >= heightSmall;
    return Scaffold(
      primary: true,
      resizeToAvoidBottomInset: isSmall,
      body: SafeArea(
          child: Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Login Passcode',
            backButton: HeaderBarBackButton(),
          ),
          // Body
          PaddingTop(
              child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: _text[_currentStep],
                  style: textStylePoppinsBold20,
                ),
                TextSpan(
                  text: ' passcode',
                  style: textStylePoppinsBold20Blue,
                ),
              ],
            ),
          )),
          if (!isSmall) const SizedBox(height: 40),
          Container(
              alignment: Alignment.center,
              padding: paddingAll20,
              width: 170,
              child: TextField(
                autofocus: true,
                controller: _ctrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: true,
                showCursor: false,
                maxLength: 6,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                style: const TextStyle(fontSize: 32),
                // decoration: const InputDecoration(
                //   border: OutlineInputBorder(borderSide: BorderSide.none),
                // ),
                onChanged: (value) => setState(() {
                  switch (_currentStep) {
                    case CurrentStep.enterCurrent:
                      _currentCode = value;
                      if (_currentCode == controller.pinCode) {
                        _currentStep = CurrentStep.enterNew;
                        _ctrl.text = '';
                      }
                      break;
                    case CurrentStep.enterNew:
                      _firstCode = value;
                      if (_firstCode.length == 6) {
                        _currentStep = CurrentStep.enterNewAgain;
                        _ctrl.text = '';
                      }
                      break;
                    case CurrentStep.enterNewAgain:
                      _secondCode = value;
                      break;
                  }
                }),
              )),
          Expanded(child: Container()),
          // Footer
          if (_currentStep == CurrentStep.enterNewAgain &&
              _secondCode == _firstCode)
            Padding(
              padding: paddingFooter,
              child: PrimaryButtonBig(
                  text: 'Change Passcode',
                  onPressed: () async {
                    await context
                        .read<SettingsController>()
                        .setPinCode(_secondCode);
                    Navigator.of(context).pop();
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => BottomSheetWidget(
                              icon: const IconOf.secrets(
                                radius: 40,
                                size: 40,
                                bage: BageType.ok,
                              ),
                              titleString: 'Passcode changed',
                              textString:
                                  'Your login passcode was\nchanged successfully.',
                              footer: PrimaryButtonBig(
                                text: 'Done',
                                onPressed: Navigator.of(context).pop,
                              ),
                            ));
                  }),
            ),
        ],
      )),
    );
  }
}
