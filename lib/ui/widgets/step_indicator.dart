import 'package:flutter/material.dart';

class StepIndicator extends StatelessWidget {
  const StepIndicator({
    required this.stepCurrent,
    required this.stepsCount,
    this.padding = 12,
    super.key,
  });

  final int stepCurrent;
  final int stepsCount;
  final int padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final height = theme.progressIndicatorTheme.linearMinHeight ?? 4;
    return CustomPaint(
      size: Size.fromHeight(height),
      painter: _ScannerOverlay(
        stepCurrent: stepCurrent,
        stepsCount: stepsCount,
        strokeWidth: height,
        padding: padding,
        foregroundColor:
            theme.progressIndicatorTheme.color ?? theme.colorScheme.primary,
        backgroundColor: theme.progressIndicatorTheme.refreshBackgroundColor ??
            theme.colorScheme.secondary,
      ),
    );
  }
}

class _ScannerOverlay extends CustomPainter {
  _ScannerOverlay({
    required this.stepCurrent,
    required this.stepsCount,
    required this.padding,
    required double strokeWidth,
    required Color foregroundColor,
    required Color backgroundColor,
  })  : _dy = strokeWidth / 2,
        _foregroundPaint = Paint()
          ..color = foregroundColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
        _backgroundPaint = Paint()
          ..color = backgroundColor
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

  final int stepCurrent;
  final int stepsCount;
  final int padding;

  final double _dy;
  final Paint _foregroundPaint;
  final Paint _backgroundPaint;

  @override
  bool shouldRepaint(_) => true;

  @override
  void paint(Canvas canvas, Size size) {
    final stepSize = (size.width - padding * stepsCount + padding) / stepsCount;
    for (var i = 0; i < stepsCount; i++) {
      final dx = i * stepSize + i * padding;
      final from = Offset(dx, _dy);
      final to = Offset(dx + stepSize, _dy);
      i < stepCurrent
          ? canvas.drawLine(from, to, _foregroundPaint)
          : canvas.drawLine(from, to, _backgroundPaint);

      if (i != stepCurrent) continue;
      canvas.drawLine(from, Offset(dx + stepSize / 2, _dy), _foregroundPaint);
    }
  }
}
