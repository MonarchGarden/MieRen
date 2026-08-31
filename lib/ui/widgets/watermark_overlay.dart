import 'package:flutter/material.dart';

/// Watermark overlay for product detail images with controlled opacity and diagonal text.
class WatermarkOverlay extends StatelessWidget {
  final String watermarkText;
  final double opacity;
  final double fontSize;

  const WatermarkOverlay({
    super.key,
    this.watermarkText = 'MieRen',
    this.opacity = 0.30,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Transform.rotate(
          angle: -0.35, // Diagonal angle
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              4,
              (index) => Text(
                '$watermarkText    $watermarkText    $watermarkText',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: opacity),
                  fontSize: fontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3.0,
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: opacity * 0.8),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
