import 'package:e3tmed/common/image_widgets/HTTPImage.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  final double? width;
  final double? height;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxFit? fit;

  const ProductImage(
      {super.key,
      required this.product,
      this.width,
      this.height,
      this.borderRadius,
      this.color,
      this.fit});

  @override
  Widget build(BuildContext context) {
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
