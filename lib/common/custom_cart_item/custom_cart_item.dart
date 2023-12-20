import 'package:e3tmed/common/buttons/secondarybuttonshape.dart';
import 'package:e3tmed/common/quantity_counter/quantity_counter.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../custom_checkout_item_card/custom_order_item_widget.dart';

class CustomCartItemWidget extends StatefulWidget {
  final OrderItem orderItem;

  final void Function(OrderItem orderItem) deleteItemFromDB;
  final void Function(OrderItem orderItem) onTap;
  final void Function(int quantity) callBack;

  const CustomCartItemWidget(
      {Key? key,
      required this.orderItem,
      required this.deleteItemFromDB,
      required this.onTap,
      required this.callBack})
      : super(key: key);

  @override
  State<CustomCartItemWidget> createState() => _CustomCartItemWidgetState();
}

class _CustomCartItemWidgetState extends State<CustomCartItemWidget> {
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.onTap(widget.orderItem),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            OrderItemWidget(
              orderItem: widget.orderItem,
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!widget.orderItem.maintenance && !widget.orderItem.isAgent)
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                            text: "Price:  ",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16)),
                        TextSpan(
                            text:
                                "${(widget.orderItem.totalPrice! * widget.orderItem.quantity)} SAR",
                            style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  )
                else if (widget.orderItem.maintenance)
                  Text(strings.getStrings(AllStrings.maintenanceTitle),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                else if (widget.orderItem.isAgent)
                  Text(strings.getStrings(AllStrings.agentVisitTitle),
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                QuantityCounter(
                  initialValue: widget.orderItem.quantity,
                  max: widget.orderItem.product.stock,
                  onQuantityChange: (quantity) => setState(() {
                    widget.callBack(quantity);
                    widget.orderItem.quantity = quantity;
                  }),
                ),
                SecondaryButtonShape(
                    width: 100,
                    height: 30,
                    textSize: 10,
                    text: strings.getStrings(AllStrings.deleteTitle),
                    color: Colors.red,
                    clickable: true,
                    stream: null,
                    onTap: () => widget.deleteItemFromDB(widget.orderItem))
              ],
            ),
            const Divider(
              thickness: 0.7,
            ),
          ],
        ),
      ),
    );
  }
}
