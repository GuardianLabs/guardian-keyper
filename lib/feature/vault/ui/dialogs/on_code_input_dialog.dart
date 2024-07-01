import 'package:flutter/services.dart';

import 'package:guardian_keyper/ui/widgets/common.dart';

class OnCodeInputDialog extends StatefulWidget {
  static Future<String?> show(BuildContext context) =>
      Navigator.of(context).push(
        MaterialPageRoute<String>(
          fullscreenDialog: true,
          builder: (_) => const OnCodeInputDialog(),
        ),
      );

  const OnCodeInputDialog({super.key});

  @override
  State<OnCodeInputDialog> createState() => _OnCodeInputDialogState();
}

class _OnCodeInputDialogState extends State<OnCodeInputDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldSafe(
        appBar: AppBar(
          title: const Text('Add with a Text Code'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        children: [
          // Input
          Padding(
            padding: paddingV20,
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: ' Code '),
              enableInteractiveSelection: false,
              readOnly: true,
            ),
          ),
          // Buttons
          Padding(
              padding: paddingV20,
              child: Row(
                children: [
                  // Paste
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final data =
                            await Clipboard.getData(Clipboard.kTextPlain);
                        if (data?.text == null || data!.text!.isEmpty) return;
                        final code = data.text!.trim();
                        final whiteSpace = code.lastIndexOf('\n');
                        _controller.text = whiteSpace == -1
                            ? code
                            : code.substring(whiteSpace).trim();
                      },
                      child: const Text('Paste'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add
                  Expanded(
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.of(context).pop(_controller.text),
                      child: const Text('Add'),
                    ),
                  ),
                ],
              )),
        ],
      );
}
