import 'package:e3tmed/common/image_widgets/product_image.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/material.dart';

class ProductCardItemWidget extends StatelessWidget {
  final Product product;
  final void Function(Product) onTap;

  const ProductCardItemWidget(
      {Key? key, required this.product, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(product),
      child: Card(
        elevation: 2,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: ProductImage(
                product: product,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(10),
                height: 90,
                width: 90,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    product.getProductName(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Manufactured in ${product.manufactureDate.year}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    product.getManufacturerName(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 13),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
