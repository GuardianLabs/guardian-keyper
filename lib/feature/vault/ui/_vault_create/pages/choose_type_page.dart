import 'package:guardian_keyper/ui/widgets/common.dart';
import 'package:guardian_keyper/ui/widgets/icon_of.dart';

import '../vault_create_presenter.dart';
import '../widgets/selectable_card.dart';

class ChooseTypePage extends StatelessWidget {
  const ChooseTypePage({super.key});

  @override
  Widget build(final BuildContext context) => Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Add a new Vault',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          Expanded(
            child: ListView(
              padding: paddingAll20,
              children: [
                // Your Devices
                GestureDetector(
                  onTap: context.read<VaultCreatePresenter>().nextPage,
                  child: SelectableCard(
                      isSelected: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const IconOf.yourDevices(bgColor: clWhite),
                          Padding(
                            padding: paddingTop20,
                            child: Text(
                              'Your Devices',
                              style: textStylePoppins616,
                            ),
                          ),
                          Padding(
                            padding: paddingTop12,
                            child: Text(
                              'Your devices and devices that belong to your '
                              'Guardians, trusted people, friends and family '
                              'who act on your behalf when required.',
                              style: textStyleSourceSansPro414Purple,
                            ),
                          ),
                        ],
                      )),
                ),
                const Padding(padding: paddingTop20),
                // Fiduciaries
                SelectableCard(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const IconOf.fiduciaries(bgColor: clWhite),
                        Container(
                          height: 28,
                          width: 53,
                          alignment: Alignment.center,
                          decoration: boxDecoration.copyWith(
                            color: clIndigo500,
                          ),
                          child: Text('Soon', style: textStyleSourceSansPro614),
                        ),
                      ],
                    ),
                    Padding(
                      padding: paddingTop20,
                      child: Text('Fiduciaries', style: textStylePoppins616),
                    ),
                    Padding(
                      padding: paddingTop12,
                      child: Text(
                        'Trusted appointed fiduciary third parties appointed to '
                        'act as Guardians on your behalf on a professional basis.',
                        style: textStyleSourceSansPro414Purple,
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      );
}
