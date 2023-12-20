import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/custom_checkout_item_card/custom_order_item_widget.dart';
import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/request/agent_request_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/agent_request_card/agent_request_card.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/main_loading.dart';
import '../../../common/price_summary_widget.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../models/category.dart';
import '../../../models/order.dart';

class AgentRequestScreenArgs {
  final Category category;
  final bool maintenanceMode;

  AgentRequestScreenArgs(
      {required this.category, required this.maintenanceMode});
}

class AgentRequestScreen extends ScreenWidget {
  AgentRequestScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentRequestScreenState createState() => AgentRequestScreenState(context);
}

class AgentRequestScreenState
    extends BaseStateObject<AgentRequestScreen, AgentRequestViewModel> {
  AgentRequestScreenState(BuildContext context)
      : super(() => AgentRequestViewModel(context));
  final string = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(string.getStrings(AllStrings.requestsTitle)),
          elevation: 0,
        ),
        body: Directionality(
          textDirection:
              useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  onTap: (value) {
                    viewModel.getRequestDataWithFilter(
                        AgentRequestFilters.values[value]);
                  },
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  tabs: [
                    Tab(
                      text: string.getStrings(AllStrings.allTitle),
                    ),
                    Tab(
                      text: string.getStrings(AllStrings.newTitle),
                    ),
                    Tab(
                      text: string.getStrings(AllStrings.repairTitle),
                    ),
                  ]),
              Expanded(
                child: StreamBuilder<List<AgentRequest>?>(
                  stream: viewModel.requests,
                  builder: (context, snapshot) => snapshot.data == null
                      ? const Center(
                          child: MainLoadinIndicatorWidget(),
                        )
                      : Center(
                          child: snapshot.data!.isNotEmpty
                              ? ListView(
                                  children: snapshot.data!
                                      .map(
                                        (e) => AgentRequestCardWidget(
                                          onTap: () => showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) => buildSheet(
                                                    e,
                                                    viewModel.loadingStream,
                                                    () => viewModel
                                                        .acceptRequest(e),
                                                  )),
                                          agentRequest: e,
                                          viewDetails: (request) =>
                                              showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder: (context) =>
                                                      buildSheet(
                                                        request,
                                                        viewModel.loadingStream,
                                                        () => viewModel
                                                            .acceptRequest(e),
                                                      )),
                                          onAccepting: (request) {
                                            viewModel.acceptRequest(request);
                                          },
                                          onRejecting: (request) {},
                                        ),
                                      )
                                      .toList(),
                                )
                              : Text(string
                                  .getStrings(AllStrings.yourListIsEmptyTitle)),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSheet(AgentRequest request, Stream<bool> loadingStream,
      void Function() onAccept) {
    // double totalRequest = request.items
    //     .map((e) => e.totalPrice)
    //     .reduce((value, element) => value! + element!)!
    //     .toDouble();
    // double totalVat = 115;
    final strings = Injector.appInstance.get<IStrings>();
    return DraggableScrollableSheet(
      initialChildSize: 0.96,
      builder: (BuildContext context, ScrollController scrollController) =>
          Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            string.getStrings(AllStrings.requestsTitle),
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.close,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  request.addedDate.year.toString(),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            )
          ],
        ),
        body: Directionality(
          textDirection:
              useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RequestOuterDetailsWidget(
                    icon: Icons.person_outlined,
                    title:
                        "${request.user.firstName} ${request.user.lastName}"),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RequestOuterDetailsWidget(
                    icon: Icons.location_on_outlined,
                    title: request.address.address),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RequestOuterDetailsWidget(
                    icon: Icons.error_outline,
                    title:
                        "${request.items.map((e) => e.product.getProductName()).toList()}"),
              ),
              const Divider(
                thickness: 0.7,
                color: Colors.black,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView(
                    children: request.items
                        .map((e) => OrderItemWidget(
                            displayDetails: !e.isAgent,
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
                                images: e.images
                                    ?.map((x) => OrderItemImage(data: x.data))
                                    .toList(),
                                isAgent: e.isAgent,
                                maintenance: e.maintenance)))
                        .toList(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: PriceSummaryWidget(orderId: request.id),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Text(strings.getStrings(AllStrings.priceDetailsTitle)),
                //     const SizedBox(
                //       height: 20,
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           strings.getStrings(AllStrings.totalTitle),
                //           style: const TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16),
                //         ),
                //         Text(
                //           "$totalRequest SAR",
                //           style: const TextStyle(
                //               color: Colors.black,
                //               fontWeight: FontWeight.bold,
                //               fontSize: 16),
                //         )
                //       ],
                //     ),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           strings.getStrings(AllStrings.productPriceTitle),
                //           style:
                //               const TextStyle(fontSize: 14, color: Colors.grey),
                //         ),
                //         Text(
                //           "${request.items.map((e) => e.totalPrice).toString()} SAR",
                //           style:
                //               const TextStyle(fontSize: 14, color: Colors.grey),
                //         )
                //       ],
                //     ),
                //     const SizedBox(
                //       height: 10,
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Text(
                //           strings.getStrings(AllStrings.agentFeesTitle),
                //           style:
                //               const TextStyle(fontSize: 14, color: Colors.cyan),
                //         ),
                //         Text(
                //           "$totalVat SAR",
                //           style:
                //               const TextStyle(fontSize: 14, color: Colors.cyan),
                //         )
                //       ],
                //     )
                //   ],
                // ),
              ),
              const Divider(
                thickness: 0.7,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: PrimaryButtonShape(
                          width: 75,
                          height: 40,
                          text: strings.getStrings(AllStrings.acceptTitle),
                          color: Theme.of(context).colorScheme.secondary,
                          stream: loadingStream,
                          onTap: onAccept),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
