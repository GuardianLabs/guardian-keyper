import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme_data.dart';
import '../../widgets/common.dart';
import '../../widgets/icon_of.dart';

import 'recovery_group_create_controller.dart';
// import '../recovery_group_model.dart';

class RecoveryGroupCreateView extends StatelessWidget {
  const RecoveryGroupCreateView({Key? key}) : super(key: key);

  static const routeName = '/recovery_group_create';
  // static const _paddingV5 = EdgeInsets.only(top: 5, bottom: 5);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RecoveryGroupCreateController(),
      child: Consumer<RecoveryGroupCreateController>(
        builder: (context, value, child) {
          switch (value.currentScreen) {
            case Screen.chooseType:
              return const Scaffold(body: _ChooseType());
            case Screen.inputName:
              return const Scaffold(
                resizeToAvoidBottomInset: false,
                body: _InputName(),
              );
            case Screen.addGuardians:
              return const Scaffold(body: _AddGuardian());
          }
        },
      ),
    );
  }
}

class _ChooseType extends StatelessWidget {
  const _ChooseType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupCreateController>(context);
    return Column(
      children: [
        // Header
        const HeaderBar(
          caption: 'Create Recovery Group',
          closeButton: HeaderBarCloseButton(),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              GestureDetector(
                onTap: () => state.deviceType = DeviceType.devices,
                child: SimpleCard(
                  isSelected: state.deviceType == DeviceType.devices,
                  bgColor: clIndigo700,
                  caption: 'Devices',
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                  leading: const IconOf.group(),
                ),
              ),
              const SizedBox(height: 10),
              SimpleCard(
                isSelected: state.deviceType == DeviceType.fiduciaries,
                bgColor: clIndigo800,
                caption: 'Fiduciaries',
                text:
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                leading: const IconOf.group(),
                trailing: Container(
                  height: 28,
                  width: 53,
                  alignment: Alignment.center,
                  decoration: decorBlueButton,
                  child: const Text('Soon'),
                ),
              ),
            ],
          ),
        ),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: state.deviceType == null
                ? null
                : () => state.currentScreen = Screen.inputName,
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}

class _InputName extends StatelessWidget {
  const _InputName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupCreateController>(context);
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add Name',
          backButton: HeaderBarBackButton(
            onPressed: () => state.currentScreen = Screen.chooseType,
          ),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Create a '),
                TextSpan(text: 'name', style: TextStyle(color: clBlue)),
                TextSpan(text: ' for your\n recovery group'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: TextField(
            autofocus: true,
            // controller: _ctrl,
            restorationId: 'RecoveryGroupNameInput',
            keyboardType: TextInputType.name,
            // onChanged: (value) => setState(() => _filter = value),
            decoration: InputDecoration(
              border: Theme.of(context).inputDecorationTheme.border,
              filled: Theme.of(context).inputDecorationTheme.filled,
              fillColor: Theme.of(context).inputDecorationTheme.fillColor,
              labelText: 'GROUP NAME',
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: state.deviceType == null
                ? null
                : () => state.currentScreen = Screen.addGuardians,
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}

class _AddGuardian extends StatelessWidget {
  const _AddGuardian({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RecoveryGroupCreateController>(context);
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add Guardians',
          backButton: HeaderBarBackButton(
            onPressed: () => state.currentScreen = Screen.inputName,
          ),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Padding(
          padding: const EdgeInsets.only(top: 60),
          child: RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              children: <TextSpan>[
                TextSpan(text: 'Invite '),
                TextSpan(text: 'members', style: TextStyle(color: clBlue)),
                TextSpan(text: ' to your\n recovery group'),
              ],
            ),
          ),
        ),
        Expanded(child: Container()),
        // Footer
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FooterButton(
            text: 'Continue',
            onPressed: state.deviceType == null
                ? null
                : () => state.currentScreen = Screen.inputName,
          ),
        ),
        Container(height: 50),
      ],
    );
  }
}
