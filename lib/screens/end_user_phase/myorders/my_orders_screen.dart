import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/my_orders_card_item/my_orders_widget.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/my_orders_view_model.dart';

class MyOrderScreen extends ScreenWidget {
  MyOrderScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  MyOrderScreenState createState() => MyOrderScreenState(context);
}

class MyOrderScreenState
    extends BaseStateObject<MyOrderScreen, MyOrderViewModel> {
  MyOrderScreenState(BuildContext context)
      : super(() => MyOrderViewModel(context));

  final string = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.myOrdersTitle)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8.0),
        child: Center(
          child: StreamBuilder<List<Order>?>(
            stream: viewModel.myOrdersList,
            builder: (context, snapshot) => snapshot.data == null
                ? MainLoadinIndicatorWidget(
                    hasColor: Theme.of(context).primaryColor,
                  )
                : snapshot.data!.isNotEmpty
                    ? ListView(
                        children: snapshot.data!
                            .map((e) => MyOrdersCardWidget(
                                  order: e,
                                  onTap: () =>
                                      viewModel.navigateToOrderDetails(e),
                                ))
                            .toList(),
                      )
                    : Flex(
                        direction: Axis.vertical,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                string.getStrings(
                                    AllStrings.yourListIsEmptyTitle),
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
          ),
        ),
      ),
    );
  }
}
