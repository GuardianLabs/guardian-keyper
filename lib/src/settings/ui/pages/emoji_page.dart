import '/src/core/ui/widgets/emoji.dart';
import '/src/core/ui/widgets/common.dart';
import '/src/core/service/service_root.dart';

class EmojiPage extends StatefulWidget {
  static const emoji = {'Vault': emojiVault, 'Peer': emojiPeer};

  static MaterialPageRoute<void> getPageRoute(final RouteSettings settings) =>
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        settings: settings,
        builder: (_) => EmojiPage(setName: settings.arguments as String),
      );

  final String setName;

  const EmojiPage({super.key, required this.setName});

  @override
  State<EmojiPage> createState() => _EmojiPageState();
}

class _EmojiPageState extends State<EmojiPage> {
  final _selected = <int>[];

  @override
  Widget build(final BuildContext context) => ScaffoldSafe(
        child: Column(
          children: [
            // Header
            HeaderBar(
              caption: 'Emoji of ${widget.setName}',
              closeButton: const HeaderBarCloseButton(),
            ),
            // Body
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: <DataColumn>[
                    DataColumn(
                      label: Text('Emoji of ${widget.setName}'),
                    ),
                  ],
                  rows: EmojiPage.emoji[widget.setName]!
                      .map((e) => DataRow(
                            cells: [DataCell(Text(String.fromCharCode(e)))],
                            selected: _selected.contains(e),
                            onSelectChanged: (value) {
                              value! ? _selected.add(e) : _selected.remove(e);
                              setState(() {});
                            },
                          ))
                      .toList(),
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
                        _selected.map((e) => e.toRadixString(16)).join(', '),
                        subject: widget.setName,
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
