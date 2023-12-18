import 'package:guardian_keyper/consts.dart';
import 'package:guardian_keyper/ui/widgets/common.dart';

SnackBar buildSnackBar({
  String? text,
  List<TextSpan>? textSpans,
  Duration duration = snackBarDuration,
  bool isFloating = false,
  bool isError = false,
}) =>
    SnackBar(
      duration: duration,
      behavior: isFloating ? SnackBarBehavior.floating : null,
      margin: paddingAll20,
      backgroundColor: isError ? clRed : clGreen,
      content: RichText(
        text: TextSpan(
          text: text,
          children: textSpans,
          style: TextStyle(color: isError ? clWhite : clGreenDark),
        ),
      ),
    );

List<TextSpan> buildTextWithId({
  required String name,
  String? leadingText,
  String? trailingText,
  TextStyle style = const TextStyle(fontWeight: FontWeight.w600),
}) =>
    [
      if (leadingText != null) TextSpan(text: leadingText),
      TextSpan(text: '$name  ', style: style),
      if (trailingText != null) TextSpan(text: trailingText),
    ];
