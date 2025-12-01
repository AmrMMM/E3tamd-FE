import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class MyOrdersCardWidget extends StatelessWidget {
  final void Function() onTap;
  final Order order;
  final strings = Injector.appInstance.get<IStrings>();

  MyOrdersCardWidget({
    Key? key,
    required this.order,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String items = order.items
        .map(
          (e) => e.product.getProductName(),
        )
        .toString();
    double totalPrice = 0;
    order.items.map((e) => totalPrice += e.totalPrice!).toList();
    return InkWell(
      onTap: onTap,
      child: Directionality(
        textDirection: useLanguage == Languages.arabic.name
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Card(
          elevation: 5,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Directionality(
                      textDirection: useLanguage == Languages.arabic.name
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      child: Flex(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: [
                          const SizedBox(),
                          Text(
                            strings.getOrderStatusString(order.status),
                            style: const TextStyle(
                              color: Colors.orangeAccent,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Flex(direction: Axis.horizontal, children: [
                        Container(
                          color: Colors.orangeAccent,
                          width: 3,
                          height: 60,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 15),
                                softWrap: true,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                order.address.address,
                                style: const TextStyle(
                                    color: Colors.green, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 14,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${order.addedDate.day}/${order.addedDate.month}/${order.addedDate.year}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
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
                              "${order.totalPrice} SAR",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
