import 'package:e3tmed/common/image_widgets/HTTPImage.dart';
import 'package:e3tmed/common/image_widgets/thumbnail_data.dart';
import 'package:e3tmed/models/category.dart';
import 'package:flutter/material.dart';

class CategoryImage extends StatelessWidget {
  final Category category;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;

  const CategoryImage(
      {super.key,
      required this.category,
      this.width,
      this.height,
      this.color,
      this.fit});

  @override
  Widget build(BuildContext context) {
    // Prefer the inline thumbnail delivered with the category list - no extra request.
    final thumbnail = decodeThumbnail(category.thumbnail);
    if (thumbnail != null) {
      return Material(
        color: Colors.transparent,
        child: Image.memory(
          thumbnail,
          // Keep showing the current frame while a rebuild (e.g. a route push)
          // re-resolves the image, instead of flashing blank.
          gaplessPlayback: true,
          filterQuality: FilterQuality.high,
          width: width,
          height: height,
          color: color,
          fit: fit,
        ),
      );
    }

    // Fallback for categories without a thumbnail: the full-size image endpoint.
    return HTTPImage("Category/Image",
        key: Key(category.id.toString()),
        queryArgs: {"categoryId": category.id},
        width: width,
        height: height,
        color: color,
        fit: fit);
  }
}
