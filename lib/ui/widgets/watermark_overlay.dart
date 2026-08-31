import 'package:flutter/material.dart';

/// A protective watermark overlay with diagonal brand text and transparent guard
/// layer that prevents long-press context menus and image theft.
class WatermarkOverlay extends StatelessWidget {
  final String watermarkText;
  final double opacity;
  final double fontSize;

  const WatermarkOverlay({
    super.key,
    this.watermarkText = 'MieRen © Preview • Do Not Copy',
    this.opacity = 0.22,
    this.fontSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Diagonal Watermark Text Pattern
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Transform.rotate(
                angle: -0.35, // ~-20 degrees diagonal slant
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                    4,
                    (index) => Text(
                      watermarkText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: opacity),
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.5,
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
          ),
        ),

        // 2. Transparent Guard Layer to swallow right-click & long-press save
        Positioned.fill(
          child: GestureDetector(
            onLongPress: () {}, // Swallows mobile long-press context menu
            onSecondaryTap: () {}, // Swallows web right-click menu
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }
}
