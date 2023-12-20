import 'package:e3tmed/common/image_widgets/HTTPImage.dart';
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
    return HTTPImage("Category/Image",
        queryArgs: {"categoryId": category.id},
        width: width,
        height: height,
        color: color,
        fit: fit,
        loadingColor: Colors.white);
  }
}
