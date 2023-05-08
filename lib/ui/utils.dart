import '../app/consts.dart';
import 'widgets/common.dart';

const smallScreenHeight = 600;
const mediumScreenHeight = 800;
const largeScreenHeight = 1200;

enum ScreenSize { small, medium, large, big }

ScreenSize getScreenSize(final Size size) {
  final height = size.height;
  if (height < smallScreenHeight) return ScreenSize.small;
  if (height < mediumScreenHeight) return ScreenSize.medium;
  if (height < largeScreenHeight) return ScreenSize.large;
  return ScreenSize.big;
}

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
