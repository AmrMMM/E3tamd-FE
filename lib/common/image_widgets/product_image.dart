import 'package:e3tmed/common/image_widgets/HTTPImage.dart';
import 'package:e3tmed/common/image_widgets/thumbnail_data.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  /// Grids/lists keep this true to render the lightweight inline thumbnail. Detail views pass
  /// false to force the full-resolution image from Product/Image.
  final bool preferThumbnail;

  const ProductImage(
      {super.key,
      required this.product,
      this.width,
      this.height,
      this.borderRadius,
      this.color,
      this.fit,
      this.preferThumbnail = true});

  @override
  Widget build(BuildContext context) {
    if (preferThumbnail) {
      final thumbnail = decodeThumbnail(product.thumbnail);
      if (thumbnail != null) {
        return Material(
          borderRadius: borderRadius,
          color: Colors.transparent,
          child: Image.memory(
            thumbnail,
            // Keep showing the current frame while a rebuild re-resolves the
            // image, instead of flashing blank.
            gaplessPlayback: true,
            filterQuality: FilterQuality.high,
            width: width,
            height: height,
            color: color,
            fit: fit,
          ),
        );
      }
    }

    // Full-size image endpoint: detail views, or grid tiles whose product has no thumbnail.
    return HTTPImage("Product/Image",
        key: Key(product.id.toString()),
        queryArgs: {"productId": product.id},
        borderRadius: borderRadius,
        width: width,
        height: height,
        color: color,
        fit: fit);
  }
}
