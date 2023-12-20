import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/custom_checkout_item_card/custom_order_item_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/order/agent_order_summary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/image_widgets/product_image.dart';
import '../../../common/price_summary_widget.dart';
import '../../../models/agent_requests_model.dart';
import '../../../models/order.dart';

class AgentOrderSummaryScreenArgs {
  final AgentRequest request;
  final double totalPrice;
  final void Function() onComplete;

  AgentOrderSummaryScreenArgs(
      {required this.request,
      required this.totalPrice,
      required this.onComplete});
}

class AgentOrderSummaryScreen extends ScreenWidget {
  AgentOrderSummaryScreen(BuildContext context) : super(context);

  @override
  AgentOrderSummaryScreenState createState() =>
      // ignore: no_logic_in_create_state
      AgentOrderSummaryScreenState(context);
}

class AgentOrderSummaryScreenState extends BaseStateArgumentObject<
    AgentOrderSummaryScreen,
    AgentOrderSummaryViewModel,
    AgentOrderSummaryScreenArgs> {
  AgentOrderSummaryScreenState(BuildContext context)
      : super(() => AgentOrderSummaryViewModel(context));
  double productPrice = 0;
  double extrasPrice = 0;
  double sparePrice = 0;
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    var allProductPrice =
        args!.request.items.map((element) => element.totalPrice!);
    if (allProductPrice.isNotEmpty) {
      productPrice =
          allProductPrice.reduce((value, element) => value + element);
    }
    final allExtrasPrice = args!.request.items
        .expand((e) => e.extras)
        .map((e) => e.extraElement?.price ?? 0);
    if (allExtrasPrice.isNotEmpty) {
      extrasPrice = allExtrasPrice.reduce((value, element) => value + element);
    }

    final allSparePrice = args!.request.items
        .expand((e) => e.extraProducts!)
        .map((e) => e.purchasePrice ?? 0);
    if (allSparePrice.isNotEmpty) {
      sparePrice = allSparePrice.reduce((value, element) => value + element);
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(strings.getStrings(AllStrings.orderSummaryTitle)),
        ),
        body: Directionality(
            textDirection:
                useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          args!.request.items[0].product.getCategoryName(),
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${args!.request.addedDate.day}-${args!.request.addedDate.month}-${args!.request.addedDate.year}",
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const Divider(
                          thickness: 0.7,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "${args!.request.user.firstName} ${args!.request.user.lastName}",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () => viewModel
                              .callThisNumber(args!.request.user.phoneNumber),
                          child: Row(
                            children: [
                              Icon(
                                Icons.wifi_calling_3,
                                color: Theme.of(context).colorScheme.secondary,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                args!.request.user.phoneNumber,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 14),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              args!.request.user.address!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Divider(
                          thickness: 0.7,
                        ),
                        Column(
                          children: args!.request.items
                              .map((e) => OrderItemWidget(
                                  displayDetails: true,
                                  orderItem: OrderItem(
                                      quantity: e.quantity,
                                      color: e.color,
                                      product: e.product,
                                      totalPrice: e.totalPrice,
                                      priceWithoutExtras: e.priceWithoutExtras,
                                      thickness: e.thickness,
                                      motor: e.motor,
                                      additionalNotes: e.additionalNotes,
                                      dimension: e.dimension,
                                      extras: e.extras,
                                      extraProducts: e.extraProducts,
                                      images: e.images
                                          ?.map((x) =>
                                              OrderItemImage(data: x.data))
                                          .toList(),
                                      isAgent: e.isAgent,
                                      maintenance: e.maintenance)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  PriceSummaryWidget(
                      orderId: args!.request.id,
                      orderItems: args!.request.items),
                  // Column(
                  //   children: [
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           strings.getStrings(AllStrings.priceDetailsTitle),
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 16,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //         const SizedBox(),
                  //       ],
                  //     ),
                  //     const SizedBox(
                  //       height: 7,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           strings.getStrings(AllStrings.productPriceTitle),
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         Text(
                  //           "$productPrice SAR",
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(
                  //       height: 7,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           strings
                  //               .getStrings(AllStrings.extrasAndServicesTitle),
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${extrasPrice + sparePrice} SAR",
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(
                  //       height: 7,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           strings.getStrings(AllStrings.vatTitle),
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${args!.totalPrice - productPrice - extrasPrice - sparePrice} SAR",
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.grey,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     const SizedBox(
                  //       height: 7,
                  //     ),
                  //     Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         Text(
                  //           strings.getStrings(AllStrings.totalTitle),
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //         Text(
                  //           "${args!.totalPrice}SAR",
                  //           style: const TextStyle(
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 12,
                  //             color: Colors.black,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),
                  PrimaryButtonShape(
                      width: double.infinity,
                      text: strings.getStrings(AllStrings.confirmOrderTitle),
                      color: Theme.of(context).colorScheme.secondary,
                      stream: viewModel.loading,
                      onTap: () {
                        viewModel.confirmOrder(args!.request);
                      }),
                ],
              ),
            )));
  }
}

class _ProductDetailsWidget extends StatefulWidget {
  final OrderItem item;

  const _ProductDetailsWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<_ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<_ProductDetailsWidget> {
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProductImage(
                  key: Key(widget.item.product.id.toString()),
                  product: widget.item.product,
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.product.getProductName(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      if (widget.item.maintenance)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text(
                              strings.getStrings(AllStrings.maintenanceTitle),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      if (!widget.item.product.withExtraDetails)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text(
                              strings.getStrings(AllStrings.sparePartsTitle),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      if (widget.item.isAgent)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 1.0),
                          child: Text(
                              strings.getStrings(AllStrings.agentVisitTitle),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text("Price ${widget.item.totalPrice} SAR",
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 13)),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 0.7,
          ),
        ],
      ),
    );
  }
}
