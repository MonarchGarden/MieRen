import 'package:flutter/material.dart';

/// A full-screen interactive image viewer supporting pinch-to-zoom, panning,
/// and high-resolution rendering.
class FullScreenImageViewer extends StatefulWidget {
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
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> with WidgetsBindingObserver {
  bool _isObscured = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Obscure image during screenshot capture or app switcher focus loss
    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused || state == AppLifecycleState.hidden) {
      if (mounted) {
        setState(() {
          _isObscured = true;
        });
      }
    } else if (state == AppLifecycleState.resumed) {
      if (mounted) {
        setState(() {
          _isObscured = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.96),
      body: SafeArea(
        child: Stack(
          children: [
            // Center content with InteractiveViewer for zoom & pan + Dense Watermark
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: 'fullscreen_${widget.imageAsset}',
                  child: _isObscured
                      ? Container(
                          width: double.infinity,
                          height: 350,
                          color: const Color(0xFF111111),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.security, size: 54, color: Colors.white70),
                              SizedBox(height: 12),
                              Text(
                                'Pratinjau Terlindungi\nTangkapan Layar Dilarang',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      : Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.contain,
                          cacheWidth: 800,
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
                  if (widget.title != null) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (widget.subtitle != null)
                            Text(
                              widget.subtitle!,
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
