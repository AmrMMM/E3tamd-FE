import 'package:e3tmed/common/buttons/secondarybuttonshape.dart';
import 'package:e3tmed/common/customalertdialog/item_take_action_dialog.dart';
import 'package:e3tmed/common/dropdownmenu/field_drop_down_menu.dart';
import 'package:e3tmed/common/multi_select_list/multi_select_list.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/price.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/screens/agent_phase/order/additional_custom_widgets/order_details_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../../DI.dart';

class AddDimensionsWidget extends StatefulWidget {
  final void Function(String dimension, String thickness, String color,
      Motor? motor, List<ExtraModel> extras) navigateToCheckout;
  final void Function(Product product, String? dimension, String? thickness,
      String? color, Motor? motor, List<ExtraModel> extras) addToCart;
  final void Function(String dimension, String thickness, Motor? motor,
      List<ExtraModel> extras) calculatePrice;
  final Product product;
  final List<Motor>? motors;
  final Stream<PriceDTO?> priceStream;

  const AddDimensionsWidget(
      {Key? key,
      required this.navigateToCheckout,
      required this.addToCart,
      required this.product,
      required this.motors,
      required this.priceStream,
      required this.calculatePrice})
      : super(key: key);

  @override
  State<AddDimensionsWidget> createState() => _AddDimensionsWidgetState();
}

class _AddDimensionsWidgetState extends State<AddDimensionsWidget> {
  String dimensions = "";
  String thickness = "";
  String color = "";
  Motor? motor;
  final strings = Injector.appInstance.get<IStrings>();
  late List<ExtraModel> productAvailableExtrasList;
  final List<ExtraModel> selectedExtrasList = [];
  bool isSaveClickable = false;

  @override
  void initState() {
    super.initState();
    productAvailableExtrasList =
        //comment this line to test the functionality of the list
        widget.product.availableExtras ?? [];
  }

  @override
  void setState(VoidCallback cb) {
    super.setState(cb);
    if (dimensions.isNotEmpty &&
        thickness.isNotEmpty &&
        color.isNotEmpty &&
        ((widget.motors?.isEmpty ?? true) || motor != null)) {
      super.setState(() {
        isSaveClickable = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldDropDownMenu(
              hintText: strings.getStrings(AllStrings.dimensionsTitle),
              items: widget.product.availableDimensions ?? [],
              onChanged: (index, value) {
                setState(() {
                  dimensions = value!;
                });
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: FieldDropDownMenu(
                hintText: strings.getStrings(AllStrings.thicknessTitle),
                items: widget.product.availableThickness ?? [],
                onChanged: (index, value) {
                  setState(() {
                    thickness = value!;
                  });
                },
              )),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: FieldDropDownMenu(
                hintText: strings.getStrings(AllStrings.colorTitle),
                items: widget.product.availableColors ?? [],
                onChanged: (index, value) {
                  setState(() {
                    color = value!;
                  });
                },
              ))
            ],
          ),
          if (widget.motors?.isNotEmpty ?? false)
            FieldDropDownMenu(
              hintText: strings.getStrings(AllStrings.motorTitle),
              items: widget.motors!.map((e) => e.getMotorName()).toList(),
              onChanged: (index, value) {
                setState(() {
                  motor = widget.motors![index];
                });
              },
            ),
          if (productAvailableExtrasList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: InkWell(
                onTap: () => openBottomSheet(
                    productAvailableExtrasList,
                    context,
                    strings.getStrings(AllStrings.extrasAndServicesTitle),
                    (data) {},
                    MultiSelectList(
                      items: productAvailableExtrasList
                          .where((element) =>
                              !selectedExtrasList.contains(element))
                          .toList(),
                      titleSelector: (value) => value.getName(),
                      priceSelector: (value) => value.price,
                      selectedItems: (values) => setState(() {
                        selectedExtrasList.addAll(values);
                      }),
                    )),
                child: Text(
                  strings.getStrings(AllStrings.addExtrasTitle),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          if (selectedExtrasList.isNotEmpty)
            Column(
              children: selectedExtrasList
                  .map((e) => PartsAndExtrasWidget(
                      itemName: e.getName(),
                      itemPrice: e.price,
                      removeItem: () => setState(() {
                            selectedExtrasList.remove(e);
                          })))
                  .toList(),
            ),
          const SizedBox(
            height: 15,
          ),
          SecondaryButtonShape(
            width: double.infinity,
            text: strings.getStrings(AllStrings.saveAndContinueTitle),
            color: Theme.of(context).colorScheme.secondary,
            stream: null,
            clickable: isSaveClickable,
            onTap: () {
              widget.calculatePrice(
                  dimensions, thickness, motor, selectedExtrasList);
              showPopUpDialog(
                  context, widget.navigateToCheckout, widget.addToCart);
            },
          )
        ],
      ),
    );
  }

  void showPopUpDialog(
      BuildContext context,
      void Function(String dimension, String thickness, String color,
              Motor? motor, List<ExtraModel> extras)
          navigateToCheckout,
      void Function(Product product, String? dimension, String? thickness,
              String? color, Motor? motor, List<ExtraModel> extras)
          addToCart) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return Dialog(
              child: ItemTakeActionDialog(
            items: [
              OrderItem(
                  product: widget.product,
                  motor: motor,
                  dimension: dimensions,
                  thickness: thickness,
                  color: color,
                  totalPrice: null,
                  priceWithoutExtras: null,
                  isAgent: false,
                  additionalNotes: "",
                  maintenance: false,
                  extras: selectedExtrasList
                      .map((e) => OrderItemExtraElement(
                          extraElementId: e.id, quantity: 1))
                      .toList(),
                  quantity: 1,
                  images: [])
            ],
            onCheckout: () {
              Navigator.of(context).pop();
              navigateToCheckout(
                  dimensions, thickness, color, motor, selectedExtrasList);
            },
            addToCart: () {
              Navigator.of(context).pop();
              addToCart(widget.product, dimensions, thickness, color, motor,
                  selectedExtrasList);
            },
          ));
        });
  }

  void openBottomSheet(
    List<ExtraModel?> list,
    BuildContext context,
    String header,
    void Function(String data) returnData,
    Widget? customWidget,
  ) {
    final string = Injector.appInstance.get<IStrings>();
    showModalBottomSheet(
      context: context,
      builder: (context) =>
          customWidget ??
          MyBottomSheetDialog(
              customWidget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    "${string.getStrings(AllStrings.enterTitle)} $header",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              ),
              const Divider(
                thickness: 0.7,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: Text(
                  "${string.getStrings(AllStrings.enterTitle)} $header",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => returnData(e!.getName()),
                          title: Text(e.toString()),
                        ))
                    .toList(),
              ),
            ],
          )),
    );
  }
}
