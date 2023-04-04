import 'package:flutter_svg/svg.dart';

import '/src/core/ui/widgets/emoji.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/service/service_root.dart';

class EmojiListPage extends StatefulWidget {
  static MaterialPageRoute<void> getPageRoute() =>
      MaterialPageRoute<void>(builder: (_) => const EmojiListPage());

  const EmojiListPage({super.key});

  @override
  State<EmojiListPage> createState() => _EmojiListPageState();
}

class _EmojiListPageState extends State<EmojiListPage> {
  final _selected = <String>[];

  @override
  Widget build(final BuildContext context) {
    int i = 0;
    return ScaffoldSafe(
      child: Column(
        children: [
          // Header
          const HeaderBar(
            caption: 'Emoji List',
            closeButton: HeaderBarCloseButton(),
          ),
          // Body
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Number')),
                  DataColumn(label: Text('Emoji')),
                ],
                rows: emojiList.map((e) {
                  return DataRow(
                    cells: [
                      DataCell(Text((i++).toString())),
                      DataCell(
                        SvgPicture.asset(e, package: 'emojicloud'),
                      )
                    ],
                    selected: _selected.contains(e),
                    onSelectChanged: (value) {
                      value! ? _selected.add(e) : _selected.remove(e);
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: paddingAll20,
            child: PrimaryButton(
              text: 'Share',
              onPressed: () {
                final box = context.findRenderObject() as RenderBox?;
                GetIt.I<ServiceRoot>().platformService.share(
                      _selected.map((e) => e).join(', '),
                      sharePositionOrigin:
                          box!.localToGlobal(Offset.zero) & box.size,
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
