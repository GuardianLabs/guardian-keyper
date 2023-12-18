import '../../consts.dart';
import '../widgets/common.dart';

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
