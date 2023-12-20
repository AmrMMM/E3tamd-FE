import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/order/agent_order_status_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/custom_checkout_item_card/custom_order_item_widget.dart';
import '../../../common/image_widgets/product_image.dart';
import '../../../common/price_summary_widget.dart';
import '../../../models/agent_requests_model.dart';
import '../../../models/order.dart';
import 'additional_custom_widgets/order_details_custom_widgets.dart';

class AgentOrderStatusScreenArgs {
  final AgentRequest request;
  final Function() onCompleteCallBack;

  AgentOrderStatusScreenArgs(
      {required this.request, required this.onCompleteCallBack});
}

class AgentOrderStatusScreen extends ScreenWidget {
  AgentOrderStatusScreen(BuildContext context) : super(context);

  @override
  AgentOrderStatusScreenState createState() =>
      // ignore: no_logic_in_create_state
      AgentOrderStatusScreenState(context);
}

class AgentOrderStatusScreenState extends BaseStateArgumentObject<
    AgentOrderStatusScreen,
    AgentOrderStatusViewModel,
    AgentOrderStatusScreenArgs> {
  AgentOrderStatusScreenState(BuildContext context)
      : super(() => AgentOrderStatusViewModel(context));

  final strings = Injector.appInstance.get<IStrings>();
  Color confirmColor = Colors.white;
  Color completeColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    double totalPrice = args!.request.items
        .map((e) => e.totalPrice!)
        .reduce((value, element) => value + element);
    double extrasTotalPrice = 0;
    var extrasList = args!.request.items.expand((element) => element.extras);
    if (extrasList.isNotEmpty) {
      extrasTotalPrice = extrasList
          .map((e) => e.extraElement?.price ?? 0)
          .reduce((value, element) => value + element);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.orderDetailsTitle)),
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
                      strings.getOrderStatusString(args!.request.status),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "${args!.request.addedDate.day}-${args!.request.addedDate.month}-${args!.request.addedDate.year}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Divider(
                      thickness: 0.7,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: args!.request.status ==
                                                OrderStatus.confirmed ||
                                            args!.request.status ==
                                                OrderStatus.finished
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : confirmColor),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                strings
                                    .getStrings(AllStrings.orderConfirmedTitle),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: args!.request.status ==
                                            OrderStatus.finished
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : confirmColor),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                strings
                                    .getStrings(AllStrings.orderInstalledTitle),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.7,
                    ),
                    UserDetailsWidget(
                      icon: Icons.person_outline,
                      header: strings.getStrings(AllStrings.nameTitle),
                      data: args!.request.user.name,
                    ),
                    InkWell(
                      onTap: () => viewModel
                          .callThisNumber(args!.request.user.phoneNumber),
                      child: UserDetailsWidget(
                        icon: Icons.wifi_calling_3_outlined,
                        header: strings.getStrings(AllStrings.phoneNumberTitle),
                        data: args!.request.user.phoneNumber,
                      ),
                    ),
                    UserDetailsWidget(
                      icon: Icons.location_on_outlined,
                      header: strings.getStrings(AllStrings.addressTitle),
                      data: args!.request.user.address!,
                    ),
                    Column(
                      children: args!.request.items
                          .map((e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  OrderItemWidget(
                                      displayDetails: true,
                                      orderItem: OrderItem(
                                          quantity: e.quantity,
                                          color: e.color,
                                          product: e.product,
                                          totalPrice: e.totalPrice,
                                          priceWithoutExtras:
                                              e.priceWithoutExtras,
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
                                          maintenance: e.maintenance)),
                                  if (e.additionalNotes != null &&
                                      e.additionalNotes!.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "${strings.getStrings(AllStrings.addNoteTitle)} : ${e.additionalNotes}",
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14),
                                      ),
                                    ),
                                ],
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: PriceSummaryWidget(orderId: args!.request.id),
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
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //   children: [
                  //     //     Text(
                  //     //       strings.getStrings(AllStrings.productPriceTitle),
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 12,
                  //     //         color: Colors.grey,
                  //     //       ),
                  //     //     ),
                  //     //     Text(
                  //     //       "$totalPrice SAR",
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 12,
                  //     //         color: Colors.grey,
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     // const SizedBox(
                  //     //   height: 7,
                  //     // ),
                  //     // if (extrasList.isNotEmpty)
                  //     //   Column(
                  //     //     children: [
                  //     //       Row(
                  //     //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //         children: [
                  //     //           Text(
                  //     //             strings.getStrings(
                  //     //                 AllStrings.extrasAndServicesTitle),
                  //     //             style: const TextStyle(
                  //     //               fontWeight: FontWeight.bold,
                  //     //               fontSize: 12,
                  //     //               color: Colors.grey,
                  //     //             ),
                  //     //           ),
                  //     //           Text(
                  //     //             "$extrasTotalPrice SAR",
                  //     //             style: const TextStyle(
                  //     //               fontWeight: FontWeight.bold,
                  //     //               fontSize: 12,
                  //     //               color: Colors.grey,
                  //     //             ),
                  //     //           ),
                  //     //         ],
                  //     //       ),
                  //     //       const SizedBox(
                  //     //         height: 7,
                  //     //       ),
                  //     //     ],
                  //     //   ),
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //   children: [
                  //     //     Text(
                  //     //       strings.getStrings(AllStrings.vatTitle),
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 12,
                  //     //         color: Colors.grey,
                  //     //       ),
                  //     //     ),
                  //     //     Text(
                  //     //       "${viewModel.vat} SAR",
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 12,
                  //     //         color: Colors.grey,
                  //     //       ),
                  //     //     ),
                  //     //   ],
                  //     // ),
                  //     // const SizedBox(
                  //     //   height: 7,
                  //     // ),
                  //     // Row(
                  //     //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     //   children: [
                  //     //     Text(
                  //     //       strings.getStrings(AllStrings.totalTitle),
                  //     //       style: const TextStyle(
                  //     //         fontWeight: FontWeight.bold,
                  //     //         fontSize: 12,
                  //     //         color: Colors.grey,
                  //     //       ),
                  //     //     ),
                  //     //     StreamBuilder<double>(
                  //     //         stream: viewModel.totalPriceDetails,
                  //     //         builder: (context, snapshot) {
                  //     //           return Text(
                  //     //             "${snapshot.data} SAR",
                  //     //             style: const TextStyle(
                  //     //               fontWeight: FontWeight.bold,
                  //     //               fontSize: 12,
                  //     //               color: Colors.grey,
                  //     //             ),
                  //     //           );
                  //     //         }),
                  //     //   ],
                  //     // ),
                  //   ],
                  // ),
                ),
              ),
              args!.request.status != OrderStatus.finished
                  ? PrimaryButtonShape(
                      width: double.infinity,
                      text: strings.getStrings(AllStrings.completedTitle),
                      color: Theme.of(context).colorScheme.secondary,
                      stream: viewModel.loading,
                      onTap: () {
                        viewModel.completeCurrentOrder(args!.request);
                      })
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
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
                      if (widget.item.dimension != null)
                        Text(
                          "${strings.getStrings(AllStrings.dimensionsTitle)}: ${widget.item.dimension}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      if (widget.item.thickness != null)
                        Text(
                          "${strings.getStrings(AllStrings.thicknessTitle)} : ${widget.item.thickness}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      if (widget.item.color != null)
                        Text(
                          "${strings.getStrings(AllStrings.colorTitle)} : ${widget.item.color}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      if (widget.item.motor != null)
                        Text(
                          "${strings.getStrings(AllStrings.motorTitle)}: ${widget.item.motor!.getMotorName()}",
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
