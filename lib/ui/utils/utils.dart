import '../../app/consts.dart';
import '../widgets/common.dart';

SnackBar buildSnackBar({
  final String? text,
  final List<TextSpan>? textSpans,
  final Duration duration = snackBarDuration,
  final bool isFloating = false,
  final bool isError = false,
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
