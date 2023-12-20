import 'package:e3tmed/common/custom_checkout_item_card/custom_order_item_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../DI.dart';

class BottomSheetOrderItem extends StatelessWidget {
  final OrderItem orderItem;
  final Order order;
  final strings = Injector.appInstance.get<IStrings>();

  BottomSheetOrderItem({Key? key, required this.orderItem, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 0,
            child: SizedBox(
              width: double.infinity,
              child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        const SizedBox(),
                        Text(
                          strings.getOrderStatusString(order.status!),
                          style: const TextStyle(
                            color: Colors.orangeAccent,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          const Divider(
            thickness: 0.7,
          ),
          OrderItemWidget(
            orderItem: orderItem,
            displayDetails: true,
            isImageRemovable: false,
            hasImagesSize: 55,
          ),
        ],
      ),
    );
  }
}
