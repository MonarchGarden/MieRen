import 'package:flutter/material.dart';

/// A protective watermark overlay with dense diagonal brand text pattern and transparent guard
/// layer that prevents long-press context menus, image saving, and screenshot theft.
class WatermarkOverlay extends StatelessWidget {
  final String watermarkText;
  final double opacity;
  final double fontSize;
  final bool denseGrid;

  const WatermarkOverlay({
    super.key,
    this.watermarkText = 'MieRen © Confidential Preview • Do Not Copy',
    this.opacity = 0.35,
    this.fontSize = 16,
    this.denseGrid = false,
  });

  @override
  Widget build(BuildContext context) {
    final int rowCount = denseGrid ? 8 : 5;
    final double textOpacity = opacity.clamp(0.2, 0.6);

    return Stack(
      children: [
        // 1. Dense Diagonal Watermark Grid Pattern
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Transform.rotate(
                angle: -0.38, // Diagonal slant
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    rowCount,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text(
                        '$watermarkText   •   $watermarkText',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.visible,
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: textOpacity),
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: textOpacity * 0.9),
                              blurRadius: 4,
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
        ),

        // 2. Transparent Guard Layer to swallow right-click & long-press save in mobile browsers
        Positioned.fill(
          child: GestureDetector(
            onLongPress: () {}, // Swallows mobile Chrome long-press context menu
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
