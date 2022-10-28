import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:airplane_mode_checker/airplane_mode_checker.dart';

import '/src/core/theme/theme.dart';
import '/src/core/widgets/misc.dart';
import '/src/core/widgets/common.dart';

import '../add_secret_controller.dart';
import '../widgets/add_secret_close_button.dart';

class AddSecretPage extends StatefulWidget {
  const AddSecretPage({super.key});

  @override
  State<AddSecretPage> createState() => _AddSecretPageState();
}

class _AddSecretPageState extends State<AddSecretPage> {
  var _isSecretObscure = true;
  var _airplaneModeOn = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(_showExplainer);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => AirplaneModeChecker.checkAirplaneMode().then(
        (status) => setState(
          () => _airplaneModeOn = status == AirplaneModeStatus.on,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<AddSecretController>();
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Add your Secret',
          backButton: HeaderBarBackButton(onPressed: controller.previousScreen),
          closeButton: const AddSecretCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            primary: true,
            shrinkWrap: true,
            padding: paddingH20,
            children: [
              PageTitle(
                titleSpans: [
                  TextSpan(
                    text: 'Add your Secret for ${controller.group.id.name} ',
                  ),
                  TextSpan(text: controller.group.id.emoji),
                ],
                subtitle: 'Make sure no one can see your screen.',
              ),
              // Open Settings Tile
              if (_airplaneModeOn)
                Padding(
                  padding: paddingBottom32,
                  child: ListTile(
                    leading: const Icon(
                      Icons.error_outline,
                      color: clYellow,
                      size: 40,
                    ),
                    title: Text(
                      'Turn on Airplane Mode',
                      style: textStyleSourceSansPro614,
                    ),
                    subtitle: Text(
                      'Make current step more secure',
                      style: textStyleSourceSansPro414Purple,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: AppSettings.openWirelessSettings,
                  ),
                ),
              // Input
              TextFormField(
                enableInteractiveSelection: true,
                toolbarOptions: const ToolbarOptions(
                  cut: true,
                  paste: true,
                  selectAll: true,
                ),
                keyboardType: TextInputType.multiline,
                obscureText: _isSecretObscure,
                maxLines: _isSecretObscure ? 1 : null,
                maxLength: controller.globals.maxSecretLength,
                style: textStyleSourceSansPro416,
                decoration: InputDecoration(
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  labelText: ' Your Secret ',
                  counterStyle: textStyleSourceSansPro414Purple,
                  suffix: _isSecretObscure
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
                              () => _isSecretObscure = !_isSecretObscure,
                            ),
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
                              () => _isSecretObscure = !_isSecretObscure,
                            ),
                          ),
                        ),
                ),
                onChanged: (value) => controller.secret = value,
              ),
              // Footer
              Padding(
                padding: paddingV32,
                child: Selector<AddSecretController, String>(
                  selector: (_, controller) => controller.secret,
                  builder: (_, secret, __) => PrimaryButton(
                    text: 'Continue',
                    onPressed: secret.isEmpty ? null : controller.nextScreen,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showExplainer() => showModalBottomSheet(
        context: context,
        isDismissible: true,
        isScrollControlled: true,
        builder: (context) => BottomSheetWidget(
          icon: CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              Icons.warning_rounded,
              size: 40,
              color: clYellow,
            ),
          ),
          titleString: 'Before you proceed',
          body: Container(
            decoration: boxDecoration,
            margin: paddingV12,
            padding: paddingAll20,
            child: const NumberedListWidget(list: [
              'Switch your phone to Аirplane mode',
              'Make sure no one can see your screen',
              'Copy and paste your secret to avoid typing',
            ]),
          ),
          footer: PrimaryButton(
            text: 'Got it',
            onPressed: Navigator.of(context).pop,
          ),
        ),
      );
}
