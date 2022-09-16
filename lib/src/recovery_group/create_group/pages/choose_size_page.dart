import '/src/core/theme_data.dart';
import '/src/core/widgets/common.dart';

import '../create_group_controller.dart';

class ChooseSizePage extends StatefulWidget {
  const ChooseSizePage({super.key});

  @override
  State<ChooseSizePage> createState() => _ChooseSizePageState();
}

class _ChooseSizePageState extends State<ChooseSizePage>
    with SingleTickerProviderStateMixin {
  static final _boxDecorationSelected = BoxDecoration(
    border: Border.all(color: clIndigo500),
    borderRadius: borderRadius,
    gradient: const RadialGradient(
      center: Alignment.bottomCenter,
      radius: 1.4,
      colors: [
        Color(0xFF7E4CDE),
        Color(0xFF35088B),
      ],
    ),
  );

  late final AnimationController _animationController =
      AnimationController(vsync: this, duration: const Duration(seconds: 1))
        ..forward();

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<CreateGroupController>(context);
    return Column(
      children: [
        // Header
        HeaderBar(
          caption: 'Group Size',
          backButton: HeaderBarBackButton(onPressed: controller.previousScreen),
          closeButton: const HeaderBarCloseButton(),
        ),
        // Body
        Expanded(
          child: ListView(
            padding: paddingAll20,
            children: [
              Padding(
                padding: paddingBottom20,
                child: Text(
                  'Choose how many Guardians will keep parts of your Secret',
                  style: textStylePoppins620,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: paddingBottom32,
                child: Text(
                  'You can join parts to recover your Secret at any time.',
                  style: textStyleSourceSansPro416,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: clIndigo500),
                  borderRadius: borderRadius,
                  color: clIndigo800,
                ),
                padding: paddingAll8,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.groupSize = 3;
                          _animationController.forward(from: 0);
                        },
                        child: Container(
                          decoration: controller.groupSize == 3
                              ? _boxDecorationSelected
                              : null,
                          padding: paddingAll20,
                          child: Column(
                            children: [
                              const Text('3 Guardians'),
                              Radio<int>(
                                value: 3,
                                groupValue: controller.groupSize,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.groupSize = value;
                                  }
                                  _animationController.forward(from: 0);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          controller.groupSize = 5;
                          _animationController.forward(from: 0);
                        },
                        child: Container(
                          decoration: controller.groupSize == 5
                              ? _boxDecorationSelected
                              : null,
                          padding: paddingAll20,
                          child: Column(
                            children: [
                              const Text('5 Guardians'),
                              Radio<int>(
                                value: 5,
                                groupValue: controller.groupSize,
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.groupSize = value;
                                  }
                                  _animationController.forward(from: 0);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: paddingTop32,
                child: InfoPanel.info(
                  animationController: _animationController,
                  textSpan: <TextSpan>[
                    const TextSpan(text: 'You will need atleast '),
                    TextSpan(
                      text: controller.groupSize == 3
                          ? '2 out of 3'
                          : '3 out of 5',
                      style: textStyleSourceSansPro616.copyWith(color: clWhite),
                    ),
                    const TextSpan(
                        text: ' Guardians to approve Secret recovery.'),
                  ],
                ),
              ),
              // Footer
              Padding(
                  padding: paddingV32,
                  child: PrimaryButton(
                    text: 'Continue',
                    onPressed: controller.nextScreen,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
