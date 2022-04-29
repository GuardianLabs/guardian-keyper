import 'package:flutter/material.dart';
import 'package:guardian_network/src/core/widgets/icon_of.dart';
import 'package:provider/provider.dart';

import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';

import '../add_guardian_controller.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<AddGuardianController>().sendAuthRequest();
  }

  @override
  void dispose() {
    context.read<AddGuardianController>().timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AddGuardianController>(context);
    return state.isDuplicate
        ? Column(
            children: [
              //Header
              const HeaderBar(caption: 'Add Guardian'),
              // Body
              const Padding(
                padding: paddingTop40,
                child: IconOf.owner(
                  radius: 40,
                  size: 40,
                  bage: BageType.warning,
                ),
              ),
              Padding(
                padding: paddingAll20,
                child: Text(
                  'Guardian has been already added',
                  style: textStylePoppinsBold20,
                ),
              ),
              Padding(
                padding: paddingAll20,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: textStyleSourceSansProRegular16.copyWith(
                      color: clPurpleLight,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: state.guardianName,
                        style: textStyleSourceSansProBold16.copyWith(
                            color: clWhite),
                      ),
                      const TextSpan(text: ' has been already added to the '),
                      TextSpan(
                        text: state.groupName,
                        style: textStyleSourceSansProBold16.copyWith(
                            color: clWhite),
                      ),
                      const TextSpan(text: ' Recovery Group'),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
              // Footer
              Padding(
                padding: paddingFooter,
                child: PrimaryButtonBig(
                  text: 'Done',
                  onPressed: Navigator.of(context).pop,
                ),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator.adaptive());
  }
}
