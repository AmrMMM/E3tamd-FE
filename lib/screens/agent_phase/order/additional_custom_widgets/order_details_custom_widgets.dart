import 'package:e3tmed/common/image_widgets/product_image.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../../logic/interfaces/IStrings.dart';

class AddingAdditionalInformationWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final void Function()? onTap;

  const AddingAdditionalInformationWidget({
    Key? key,
    required this.icon,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Theme.of(context).colorScheme.secondary,
                  size: 25,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MyBottomSheetDialog extends StatelessWidget {
  final Widget customWidget;

  const MyBottomSheetDialog({super.key, required this.customWidget});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: 10),
        Container(
          child: customWidget,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class UserDetailsWidget extends StatelessWidget {
  final String data;
  final String header;
  final IconData icon;

  const UserDetailsWidget({
    Key? key,
    required this.icon,
    required this.header,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.secondary,
                size: 30,
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    header,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    data,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            thickness: 0.7,
          ),
        ],
      ),
    );
  }
}

class PartsAndExtrasWidget extends StatelessWidget {
  final String itemName;
  final double itemPrice;
  final Widget? image;

  final void Function()? removeItem;

  const PartsAndExtrasWidget(
      {Key? key,
      required this.itemName,
      required this.itemPrice,
      this.removeItem,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (image != null)
                image!
              else
                //TODO: Add better image for extra items
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                  ),
                ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        itemName,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      Text("Price : $itemPrice SAR",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13)),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        removeItem != null
            ? InkWell(
                onTap: () => removeItem!(),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

class SpareProductWidget extends StatelessWidget {
  final OrderItemExtraProduct item;
  final void Function(Product item)? removeItem;

  const SpareProductWidget({
    Key? key,
    required this.item,
    this.removeItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (item.product != null)
                ProductImage(product: item.product!, width: 40, height: 40)
              else
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                  ),
                ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.product!.getProductName(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      Text("Price : ${item.purchasePrice!} SAR",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13)),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        removeItem != null
            ? InkWell(
                onTap: () => removeItem!(item.product!),
                child: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 25,
                ),
              )
            : const SizedBox()
      ],
    );
  }
}

class ProductSpecsDetailsWidget extends StatelessWidget {
  final String? title;
  final String? data;
  final void Function()? onTap;

  const ProductSpecsDetailsWidget(
      {Key? key, this.onTap, required this.title, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final IStrings _strings = Injector.appInstance.get<IStrings>();

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    data != null
                        ? data!
                        : "${_strings.getStrings(AllStrings.enterTitle)} $title",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.grey,
                size: 15,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          thickness: 0.7,
        ),
      ],
    );
  }
}
