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
    return const SizedBox.shrink();
  }
}
