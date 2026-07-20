import 'dart:typed_data';

import 'package:e3tmed/common/ImageCarousel.dart';
import 'package:e3tmed/common/image_widgets/thumbnail_data.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/models/product_image_ref.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

/// The product details header. A product can carry several images, so this shows a swipeable
/// carousel with a thumbnail strip and an "n / m" counter beneath it - the strip is the point,
/// since a plain pager gives no hint that there is anything to swipe to.
///
/// While the gallery listing loads (and for products with a single image) it renders one static
/// image instead of the carousel. Every byte on this screen arrives exactly once: the inline list
/// thumbnail is the instant placeholder, and each full-size image is prefetched once by id.
class ProductGallery extends StatefulWidget {
  final Product product;
  final double height;

  const ProductGallery({super.key, required this.product, this.height = 250});

  @override
  State<ProductGallery> createState() => _ProductGalleryState();
}

class _ProductGalleryState extends State<ProductGallery> {
  final _core = Injector.appInstance.get<ICoreLogic>();
  final _carousel = ImageCarouselController();

  List<ProductImageRef> _images = [];
  int _current = 0;

  // Fetched once per image and kept for the life of the screen. The carousel is a PageView under
  // the hood, which disposes off-screen pages - rendering from this map instead of a per-page
  // network widget means swiping back to an image never re-downloads it.
  final Map<int, Uint8List> _fullBytes = {};

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    try {
      final images = await _core.getProductImages(widget.product);
      if (!mounted) return;
      setState(() => _images = images);
      for (final image in images) {
        _loadFullImage(image.id);
      }
    } catch (_) {
      // The single-image fallback below still renders, so a failed gallery lookup costs the strip
      // rather than the whole screen.
    }
  }

  void _loadFullImage(int imageId) async {
    final bytes = await _core.getProductImageById(imageId);
    if (!mounted || bytes == null) return;
    setState(() => _fullBytes[imageId] = bytes);
  }

  // Product photos rarely match the header's wide aspect ratio, and BoxFit.cover would crop the
  // top/bottom of anything taller than that. BoxFit.contain shows the whole photo instead, matted
  // against the scaffold background so the letterboxing reads as intentional rather than as empty
  // space.
  Widget _matted(BuildContext context, Widget image) => Container(
        width: double.infinity,
        height: widget.height,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: image,
      );

  Widget _fullImage(ProductImageRef image) {
    // Until the full-size bytes arrive this renders the inline thumbnail scaled up - blurry for a
    // moment, but instant, and gaplessPlayback swaps it for the sharp version without a flash.
    return _bytesImage(_fullBytes[image.id] ?? decodeThumbnail(image.thumbnail));
  }

  Widget _bytesImage(Uint8List? bytes) {
    if (bytes == null) return SizedBox(height: widget.height);

    return Image.memory(
      bytes,
      gaplessPlayback: true,
      filterQuality: FilterQuality.high,
      fit: BoxFit.contain,
    );
  }

  // The pre-carousel state: the listing hasn't arrived yet, or the product has at most one image.
  // Deliberately not the old network-fetching ProductImage widget - that fired a full-size request
  // by productId that the per-image prefetch would immediately duplicate. The product's inline list
  // thumbnail costs nothing and the prefetch sharpens it in place.
  Widget _single() {
    if (_images.isNotEmpty) return _fullImage(_images.first);
    return _bytesImage(decodeThumbnail(widget.product.thumbnail));
  }

  @override
  Widget build(BuildContext context) {
    if (_images.length < 2) {
      return _matted(context, _single());
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            ImageCarousel(
              images:
                  _images.map((image) => _matted(context, _fullImage(image))).toList(),
              controller: _carousel,
              autoSlide: false,
              flat: true,
              // Full-width pages - no peek of the neighboring images. The thumbnail strip and the
              // counter already say there is more to swipe to.
              viewportFraction: 1.0,
              height: widget.height,
              // The thumbnail strip below already shows position, so the dot row would be a second
              // indicator saying the same thing.
              showIndicators: false,
              onPageChanged: (index) => setState(() => _current = index),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  "${_current + 1} / ${_images.length}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _thumbnailStrip(context),
      ],
    );
  }

  Widget _thumbnailStrip(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: _images.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final thumbnail = decodeThumbnail(_images[index].thumbnail);
          final selected = index == _current;

          return GestureDetector(
            onTap: () {
              _carousel.animateToPage(index);
              setState(() => _current = index);
            },
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.4),
                  width: selected ? 2 : 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: thumbnail == null
                    ? const Icon(Icons.image, color: Colors.grey)
                    : Image.memory(
                        thumbnail,
                        gaplessPlayback: true,
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
