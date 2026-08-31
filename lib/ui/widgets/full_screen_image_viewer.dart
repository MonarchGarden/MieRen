import 'package:flutter/material.dart';
import 'watermark_overlay.dart';

/// A full-screen interactive image viewer supporting pinch-to-zoom, panning,
/// and high-resolution rendering.
class FullScreenImageViewer extends StatelessWidget {
  final String imageAsset;
  final String? title;
  final String? subtitle;

  const FullScreenImageViewer({
    super.key,
    required this.imageAsset,
    this.title,
    this.subtitle,
  });

  /// Opens the full-screen viewer using a smooth fade route transition.
  static void show(
    BuildContext context, {
    required String imageAsset,
    String? title,
    String? subtitle,
  }) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        barrierColor: Colors.black87,
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: FullScreenImageViewer(
              imageAsset: imageAsset,
              title: title,
              subtitle: subtitle,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.94),
      body: SafeArea(
        child: Stack(
          children: [
            // Center content with InteractiveViewer for zoom & pan + Watermark
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: 'fullscreen_$imageAsset',
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        imageAsset,
                        fit: BoxFit.contain,
                        cacheWidth: 800, // Controlled resolution to prevent raw HD theft
                        errorBuilder: (context, error, stackTrace) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.broken_image_rounded,
                              color: Colors.white70,
                              size: 64,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Gambar tidak dapat dimuat',
                              style: TextStyle(color: Colors.white70, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const WatermarkOverlay(
                        opacity: 0.28,
                        fontSize: 20,
                        watermarkText: 'MieRen © Confidential Preview',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Header Controls: Title/Subtitle, Zoom Hint, Close Button
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  if (title != null) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null)
                            Text(
                              subtitle!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ] else
                    const Spacer(),

                  // Zoom Hint Badge
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.zoom_in_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Pinch to Zoom',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Close Button
                  Material(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
                      onPressed: () => Navigator.of(context).pop(),
                      tooltip: 'Tutup Gambar',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
