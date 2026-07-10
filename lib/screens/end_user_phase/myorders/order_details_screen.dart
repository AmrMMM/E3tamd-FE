import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../common/order_details_bottom_sheet.dart';
import '../../../viewmodels/end_user_viewmodels/order_details_viewmodel.dart';

class OrderDetailsScreenArgs {
  final Order order;
  final Function() deleteCallback;

  OrderDetailsScreenArgs({required this.order, required this.deleteCallback});
}

class OrderDetailsScreen extends ScreenWidget {
  OrderDetailsScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  OrderDetailsScreenState createState() => OrderDetailsScreenState(context);
}

class OrderDetailsScreenState extends BaseStateArgumentObject<
    OrderDetailsScreen, OrderDetailsViewModel, OrderDetailsScreenArgs> {
  OrderDetailsScreenState(BuildContext context)
      : super(() => OrderDetailsViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.viewDetailsTitle)),
      ),
      // Render from the re-fetched order (falling back to the passed order until
      // the fresh one arrives), so an order opened from an old notification does
      // not show the stale snapshot status.
      body: StreamBuilder<Order>(
        initialData: args!.order,
        stream: viewModel.order,
        builder: (context, orderSnapshot) {
          final order = orderSnapshot.data ?? args!.order;
          return Center(
            child: Flex(
              direction: Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Image.asset(
                    "assets/support.png",
                  ),
                ),
                Text(
                  strings.getUserOrderStatusInformationString(order.status!),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16),
                ),
                if (order.status != OrderStatus.finished)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      strings.getOrderAgentStatusInformationString(
                          order.status!),
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                StreamBuilder<double?>(
                  stream: viewModel.outstanding,
                  builder: (context, snapshot) {
                    final due = snapshot.data ?? 0;
                    if (due <= 0) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 8),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        onPressed: () => viewModel.payDifference(order),
                        icon:
                            const Icon(Icons.credit_card, color: Colors.white),
                        label: Text(
                          "${strings.getStrings(AllStrings.payRemainingTitle)} "
                          "(${due.toStringAsFixed(2)} SAR)",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.viewDetailsTitle),
                    color: Theme.of(context).primaryColor,
                    stream: null,
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) =>
                          OderDetailsBottomSheetWidget(order,
                              onCancelOrder: () => viewModel.cancelOrder(order),
                              onPayDifference: () =>
                                  viewModel.payDifferenceFromSheet(order)),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
