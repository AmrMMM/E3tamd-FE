import 'package:e3tmed/common/price_summary_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import 'buttons/secondarybuttonshape.dart';
import 'custom_bottom_sheet_order_item/BottomSheetOrderItem.dart';
import 'customalertdialog/custom_alert_dialog.dart';

class OderDetailsBottomSheetWidget extends StatelessWidget {
  final Order order;
  final void Function() onCancelOrder;
  final strings = Injector.appInstance.get<IStrings>();

  OderDetailsBottomSheetWidget(this.order,
      {Key? key, required this.onCancelOrder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    order.items.map((e) => totalPrice += e.totalPrice!).toList();
    var list = order.items.expand((element) => element.extras);
    double extrasPrice = list.isNotEmpty
        ? list
            .map((e) => e.purchasePrice!)
            .reduce((value, element) => value + element)
        : 0;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Center(
                child: SizedBox(
                    width: 100,
                    child: Divider(
                      thickness: 5,
                    )),
              ),
              Column(
                children: order.items
                    .map(
                        (e) => BottomSheetOrderItem(orderItem: e, order: order))
                    .toList(),
              ),
              PriceSummaryWidget(orderId: order.id),
              const SizedBox(
                height: 5,
              ),
              if (order.status == OrderStatus.unassigned ||
                  order.status == OrderStatus.pending)
                SecondaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.cancelTitle),
                    color: Colors.red,
                    clickable: true,
                    stream: null,
                    onTap: () {
                      Navigator.pop(context);
                      showPopUpDialog(context);
                    })
            ],
          ),
        ),
      ),
    );
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialogWidget(
              title: strings.getStrings(AllStrings.cancelOrderTitle),
              description: strings
                  .getStrings(AllStrings.areYouSureYouWantToCancelOrderTitle),
              onPositivePressed: () {
                Navigator.pop(context);
                onCancelOrder();
              },
            ),
          );
        });
  }
}
