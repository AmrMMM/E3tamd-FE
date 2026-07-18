import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/order_item_extensions.dart';
import 'package:e3tmed/screens/agent_phase/order/additional_custom_widgets/order_details_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../logic/interfaces/IStrings.dart';
import '../image_widgets/order_item_image_tile.dart';
import '../image_widgets/product_image.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;
  final double? hasImagesSize;
  final bool? displayDetails;
  final bool? isImageRemovable;

  const OrderItemWidget(
      {Key? key,
      required this.orderItem,
      this.hasImagesSize,
      this.displayDetails,
      this.isImageRemovable})
      : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              widget.orderItem.product != null
                  ? ProductImage(
                      product: widget.orderItem.product!,
                      width: 65,
                      height: 65,
                      fit: BoxFit.cover)
                  : Container(
                      width: 65,
                      height: 65,
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
                        widget.orderItem.productDisplayName(strings),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      Text(widget.orderItem.product?.description ?? '',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13)),
                      widget.orderItem.maintenance
                          ? Text(
                              strings.getStrings(AllStrings.maintenanceTitle),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 13))
                          : const SizedBox(),
                      if (widget.orderItem.quantity >= 0)
                        Text(
                            "${strings.getStrings(AllStrings.quantityTitle)} : ${widget.orderItem.quantity}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      if (widget.orderItem.product?.withExtraDetails != true)
                        Text(strings.getStrings(AllStrings.sparePartsTitle),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                      if (widget.orderItem.isAgent)
                        Text(strings.getStrings(AllStrings.agentVisitTitle),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if ((widget.displayDetails ?? false))
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if ((widget.orderItem.images ?? []).isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.getStrings(AllStrings.photosTitle),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Container(
                          height: widget.hasImagesSize ?? 80,
                          width: double.infinity,
                          decoration: const BoxDecoration(),
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: (widget.orderItem.images ?? [])
                                .where((e) => e.id != null)
                                .map((e) => Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: OrderItemImageTile(
                                        imageId: e.id!,
                                        size: widget.hasImagesSize ?? 65,
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 5,
              ),
              if (widget.orderItem.product?.withExtraDetails == true &&
                  !widget.orderItem.maintenance && !widget.orderItem.isAgent)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.getStrings(AllStrings.specificationTitle),
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: [
                          Text(
                            "${strings.getStrings(AllStrings.dimensionsTitle)} :${widget.orderItem.dimension}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                          Text(
                            "${strings.getStrings(AllStrings.thicknessTitle)} :${widget.orderItem.thickness}",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                          ),
                        ]),
                    const SizedBox(
                      height: 5,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${strings.getStrings(AllStrings.colorTitle)} : ${widget.orderItem.color}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (widget.orderItem.motor != null)
                      Text(
                        "${strings.getStrings(AllStrings.motorTitle)} : ${widget.orderItem.motor!.getMotorName()} - (${widget.orderItem.motor!.price} SAR)",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                  ],
                ),
              if (widget.orderItem.extras.isNotEmpty ||
                  (widget.orderItem.extraProducts ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        strings.getStrings(AllStrings.extrasAndServicesTitle),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13),
                      ),
                    ),
                    Column(
                      children: widget.orderItem.extras
                          .map((e) => PartsAndExtrasWidget(
                                itemName: e.extraElement!.getName(),
                                itemPrice: e.extraElement!.price,
                              ))
                          .toList(),
                    ),
                    if ((widget.orderItem.extraProducts ?? []).isNotEmpty)
                      Column(
                        children: widget.orderItem.extraProducts!
                            .map((e) => PartsAndExtrasWidget(
                                  itemName: e.product?.getProductName() ??
                                      strings.getStrings(
                                          AllStrings.deletedProductTitle),
                                  itemPrice: e.purchasePrice!,
                                  image: e.product != null
                                      ? ProductImage(
                                          product: e.product!,
                                          width: 40,
                                          height: 40)
                                      : null,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              if (widget.orderItem.additionalNotes?.isNotEmpty ?? false) ...[
                const SizedBox(
                  height: 10,
                ),
                Text(widget.orderItem.additionalNotes!,
                    style: const TextStyle(fontSize: 14)),
              ],
              const SizedBox(
                height: 10,
              ),
              if (!widget.orderItem.isAgent && !widget.orderItem.maintenance)
                Flex(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  direction: Axis.horizontal,
                  children: [
                    Text(
                      strings.getStrings(AllStrings.productPriceTitle),
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.money,
                          size: 14,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          "${widget.orderItem.priceWithoutExtras} SAR",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              const Divider(
                thickness: 0.7,
              ),
            ],
          )
      ],
    );
  }
}
