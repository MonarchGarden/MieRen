import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Watermark overlay featuring a staggered repeating diagonal grid of custom text
/// inspired by professional sample watermarks (e.g. stock photo watermarks).
class WatermarkOverlay extends StatelessWidget {
  final String watermarkText;
  final double opacity;
  final double fontSize;
  final double spacingX;
  final double spacingY;
  final double angle;

  const WatermarkOverlay({
    super.key,
    this.watermarkText = 'MieRen',
    this.opacity = 0.30,
    this.fontSize = 16,
    this.spacingX = 140,
    this.spacingY = 85,
    this.angle = -0.52, // ~ -30 degrees diagonal
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ClipRect(
        child: CustomPaint(
          size: Size.infinite,
          painter: _WatermarkPainter(
            watermarkText: watermarkText,
            opacity: opacity,
            fontSize: fontSize,
            spacingX: spacingX,
            spacingY: spacingY,
            angle: angle,
          ),
        ),
      ),
    );
  }
}

class _WatermarkPainter extends CustomPainter {
  final String watermarkText;
  final double opacity;
  final double fontSize;
  final double spacingX;
  final double spacingY;
  final double angle;

  _WatermarkPainter({
    required this.watermarkText,
    required this.opacity,
    required this.fontSize,
    required this.spacingX,
    required this.spacingY,
    required this.angle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final textStyle = TextStyle(
      color: Colors.white.withValues(alpha: opacity),
      fontSize: fontSize,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.5,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: opacity * 0.7),
          blurRadius: 3,
        ),
      ],
    );

    final textPainter = TextPainter(
      text: TextSpan(text: watermarkText, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textWidth = textPainter.width;
    final textHeight = textPainter.height;

    canvas.save();

    // Center of canvas for rotation
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    canvas.translate(centerX, centerY);
    canvas.rotate(angle);

    // Compute bounding box dimensions to fully cover canvas when rotated
    final absCos = math.cos(angle).abs();
    final absSin = math.sin(angle).abs();
    final boundW = size.width * absCos + size.height * absSin + spacingX * 2;
    final boundH = size.width * absSin + size.height * absCos + spacingY * 2;

    final stepX = textWidth + spacingX;
    final stepY = textHeight + spacingY;

    final startY = -boundH / 2;
    final endY = boundH / 2;
    final startX = -boundW / 2;
    final endX = boundW / 2;

    int rowIndex = 0;
    for (double y = startY; y <= endY; y += stepY) {
      // Offset alternate rows by half stepX for staggered grid pattern
      final xOffset = (rowIndex % 2 != 0) ? stepX / 2 : 0.0;
      for (double x = startX - stepX; x <= endX + stepX; x += stepX) {
        textPainter.paint(
          canvas,
          Offset(x + xOffset - textWidth / 2, y - textHeight / 2),
        );
      }
      rowIndex++;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.watermarkText != watermarkText ||
        oldDelegate.opacity != opacity ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.spacingX != spacingX ||
        oldDelegate.spacingY != spacingY ||
        oldDelegate.angle != angle;
  }
}

