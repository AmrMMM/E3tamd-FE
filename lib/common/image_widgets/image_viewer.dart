import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

/// Full-screen, zoomable image viewer with an explicit close button (the old
/// inline PhotoView dialogs only had tap-outside dismissal, which wasn't
/// discoverable). Tap outside still dismisses too.
void showImageViewer(BuildContext context, ImageProvider image) {
  showDialog(
    barrierDismissible: true,
    useSafeArea: false,
    context: context,
    builder: (context) => Stack(
      children: [
        PhotoView(
          enableRotation: false,
          filterQuality: FilterQuality.high,
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 1.8,
          backgroundDecoration:
              const BoxDecoration(color: Colors.transparent),
          imageProvider: image,
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
