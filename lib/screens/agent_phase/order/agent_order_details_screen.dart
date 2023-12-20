import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customalertdialog/add_extra_alert_dialog.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/common/multi_select_list/multi_select_list.dart';
import 'package:e3tmed/common/price_summary_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/screens/agent_phase/order/additional_custom_widgets/adding_dimensions_manually_widget.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/order/agent_order_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/image_widgets/product_image.dart';
import '../../../models/motor.dart';
import '../../../models/order.dart';
import '../../../models/product.dart';
import 'additional_custom_widgets/order_details_custom_widgets.dart';

class AgentOrderDetailsScreenArgs {
  final AgentRequest request;
  final void Function() callback;

  AgentOrderDetailsScreenArgs({required this.request, required this.callback});
}

class AgentOrderDetailsScreen extends ScreenWidget {
  AgentOrderDetailsScreen(BuildContext context) : super(context);

  @override
  AgentOrderDetailsScreenState createState() =>
      // ignore: no_logic_in_create_state
      AgentOrderDetailsScreenState(context);
}

class AgentOrderDetailsScreenState extends BaseStateArgumentObject<
    AgentOrderDetailsScreen,
    AgentOrderDetailsViewModel,
    AgentOrderDetailsScreenArgs> {
  AgentOrderDetailsScreenState(BuildContext context)
      : super(() => AgentOrderDetailsViewModel(context));

  final strings = Injector.appInstance.get<IStrings>();
  Key priceSummaryWidgetKey = GlobalKey();

  void refreshPrice() {
    setState(() {
      priceSummaryWidgetKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    args!.request.items.map((e) => totalPrice += e.totalPrice!).toList();
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
                      "${args!.request.addedDate.day}-${args!.request.addedDate.month}-${args!.request.addedDate.year}",
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const Divider(
                      thickness: 0.7,
                    ),
                    UserDetailsWidget(
                      icon: Icons.person_outline,
                      header: strings.getStrings(AllStrings.nameTitle),
                      data:
                          "${args!.request.user.firstName} ${args!.request.user.lastName}",
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
                          .map((e) => ProductDetailsWidget(
                                currentMoney: totalPrice,
                                item: e,
                                viewModel: viewModel,
                                refreshPrice: refreshPrice,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
              PriceSummaryWidget(
                  key: priceSummaryWidgetKey,
                  orderItems: args!.request.items,
                  orderId: args!.request.id),
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
              //           "$totalPrice SAR",
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
              //           "${viewModel.vat} SAR",
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
              //             color: Colors.grey,
              //           ),
              //         ),
              //         StreamBuilder<double>(
              //             stream: viewModel.totalPriceDetails,
              //             builder: (context, snapshot) {
              //               return Text(
              //                 "${snapshot.data} SAR",
              //                 style: const TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 12,
              //                   color: Colors.grey,
              //                 ),
              //               );
              //             }),
              //       ],
              //     ),
              //   ],
              // ),
              const SizedBox(
                height: 12,
              ),
              PrimaryButtonShape(
                  width: double.infinity,
                  text: strings.getStrings(AllStrings.saveAndContinueTitle),
                  color: Theme.of(context).colorScheme.secondary,
                  stream: null,
                  onTap: () => viewModel.saveAndContinue()),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductDetailsWidget extends StatefulWidget {
  final OrderItem item;
  final double currentMoney;
  final AgentOrderDetailsViewModel? viewModel;
  final void Function() refreshPrice;

  const ProductDetailsWidget({
    Key? key,
    required this.item,
    required this.currentMoney,
    required this.refreshPrice,
    this.viewModel,
  }) : super(key: key);

  @override
  State<ProductDetailsWidget> createState() => _ProductDetailsWidgetState();
}

class _ProductDetailsWidgetState extends State<ProductDetailsWidget> {
  final strings = Injector.appInstance.get<IStrings>();
  String? defaultDimensions, defaultThickness, defaultColor, note;
  Motor? defaultMotor;
  var detailsVisible = false;
  var noteVisible = false;
  var sparePartsVisible = false;
  var extrasVisible = false;
  var sparePartsList = <OrderItemExtraProduct>[];
  var extrasList = <ExtraModel>[];
  double totalSparePartsPrice = 0;
  double totalExtrasPrice = 0;
  List<Motor> motorList = [];

  @override
  void initState() {
    super.initState();
    defaultDimensions = widget.item.dimension;
    defaultThickness = widget.item.thickness;
    defaultColor = widget.item.color;
    defaultMotor = widget.item.motor;
    note = widget.item.additionalNotes;
    motorList = widget.item.product.motors ?? [];
    final widgetExtrasList = widget.item.extras;
    if (widgetExtrasList.isNotEmpty) {
      extrasList = widgetExtrasList.map((e) => e.extraElement!).toList();
    }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    widget.refreshPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImage(
                  key: Key(widget.item.product.id.toString()),
                  product: widget.item.product,
                  width: 65,
                  height: 65,
                  fit: BoxFit.cover),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.product.getProductName(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16),
                      ),
                      Text(widget.item.product.description,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 13)),
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
                      if (!widget.item.isAgent) ...[
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Price ${widget.item.totalPrice} SAR",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 13)),
                      ],
                      const SizedBox(
                        height: 15,
                      ),
                      if (widget.item.product.withExtraDetails)
                        InkWell(
                          onTap: () => setState(() {
                            detailsVisible = !detailsVisible;
                          }),
                          child: Text(
                            widget.item.isAgent
                                ? strings
                                    .getStrings(AllStrings.itemDetailsTitle)
                                : strings
                                    .getStrings(AllStrings.editDetailsTitle),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 13),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ],
          ),
          detailsVisible
              ? Column(
                  children: [
                    const Divider(
                      thickness: 0.7,
                    ),
                    ProductSpecsDetailsWidget(
                      title: strings.getStrings(AllStrings.dimensionsTitle),
                      data: defaultDimensions,
                      onTap: () => openBottomSheet(
                          widget.item.product.availableDimensions!,
                          context,
                          AllStrings.dimensionsTitle, (value) {
                        Navigator.of(context).pop();
                        setState(() {
                          defaultDimensions = value;
                          widget.viewModel!.updateItemDetails(
                              widget.item,
                              defaultDimensions,
                              defaultThickness,
                              defaultColor,
                              defaultMotor,
                              note);
                        });
                      }, null),
                    ),
                    ProductSpecsDetailsWidget(
                      title: strings.getStrings(AllStrings.thicknessTitle),
                      data: defaultThickness,
                      onTap: () => openBottomSheet(
                          widget.item.product.availableThickness!,
                          context,
                          AllStrings.thicknessTitle, (value) {
                        Navigator.of(context).pop();
                        setState(() {
                          defaultThickness = value;
                          widget.viewModel!.updateItemDetails(
                              widget.item,
                              defaultDimensions,
                              defaultThickness,
                              defaultColor,
                              defaultMotor,
                              note);
                        });
                      }, null),
                    ),
                    ProductSpecsDetailsWidget(
                      title: strings.getStrings(AllStrings.colorTitle),
                      data: defaultColor,
                      onTap: () => openBottomSheet(
                          widget.item.product.availableColors!,
                          context,
                          AllStrings.colorTitle, (value) {
                        Navigator.of(context).pop();
                        setState(() {
                          defaultColor = value;
                          widget.viewModel!.updateItemDetails(
                              widget.item,
                              defaultDimensions,
                              defaultThickness,
                              defaultColor,
                              defaultMotor,
                              note);
                        });
                      }, null),
                    ),
                    if (widget.item.product.motors?.isNotEmpty ?? false)
                      ProductSpecsDetailsWidget(
                        title: strings.getStrings(AllStrings.motorTitle),
                        data: defaultMotor != null
                            ? defaultMotor!.getMotorName()
                            : null,
                        onTap: () => openBottomSheetForMotors(
                            motorList, context, AllStrings.motorTitle, (value) {
                          Navigator.of(context).pop();
                          setState(() {
                            defaultMotor = value;
                            widget.viewModel!.updateItemDetails(
                                widget.item,
                                defaultDimensions,
                                defaultThickness,
                                defaultColor,
                                defaultMotor,
                                note);
                          });
                        }, null),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                    sparePartsList.isNotEmpty
                        ? Column(
                            children: [
                              Column(
                                children: sparePartsList
                                    .map((e) => SpareProductWidget(
                                        item: e,
                                        removeItem: (value) => setState(() {
                                              sparePartsList.remove(e);
                                              widget.viewModel!
                                                  .removeSpareFromTotal(
                                                      e.product!, widget.item);
                                              totalSparePartsPrice -=
                                                  e.purchasePrice!;
                                            })))
                                    .toList(),
                              ),
                              const Divider(
                                thickness: 0.7,
                              )
                            ],
                          )
                        : const SizedBox(),
                    StreamBuilder<List<Product>?>(
                        stream: widget.viewModel?.itemsList,
                        builder: (context, snapshot) {
                          return AddingAdditionalInformationWidget(
                              icon: Icons.add,
                              title: strings
                                  .getStrings(AllStrings.addSparePartsTitle),
                              onTap: () => snapshot.data != null &&
                                      snapshot.data!.isNotEmpty
                                  ? selectExtrasBottomSheet<
                                          OrderItemExtraProduct>(
                                      snapshot.data!
                                          .map((e) => OrderItemExtraProduct(
                                              product: e,
                                              productId: e.id,
                                              purchasePrice: e.basePrice,
                                              quantity: 1))
                                          .toList(),
                                      context, (value) {
                                      setState(() {
                                        sparePartsList.addAll(value);
                                        totalSparePartsPrice = 0;
                                        widget.viewModel!.addSpareToTotal(
                                            value, widget.item);
                                      });
                                    },
                                      (value) =>
                                          value.product!.getProductName(),
                                      (value) => value.purchasePrice!,
                                      (value) => ProductImage(
                                          product: value.product!,
                                          width: 40,
                                          height: 40))
                                  : const SizedBox());
                        }),
                    const Divider(
                      thickness: 0.7,
                    ),
                    extrasList.isNotEmpty
                        ? Column(
                            children: [
                              Column(
                                children: extrasList
                                    .map((e) => PartsAndExtrasWidget(
                                        itemName: e.getName(),
                                        itemPrice: e.price,
                                        removeItem: () => setState(() {
                                              extrasList.remove(e);
                                              widget.viewModel!
                                                  .removeExtraFromTotal(
                                                      e, widget.item);
                                            })))
                                    .toList(),
                              ),
                              const Divider(
                                thickness: 0.7,
                              )
                            ],
                          )
                        : const SizedBox(),
                    AddingAdditionalInformationWidget(
                        icon: Icons.add,
                        title: strings.getStrings(AllStrings.addExtrasTitle),
                        onTap: () => selectExtrasBottomSheet<ExtraModel>(
                                widget.item.product.availableExtras ?? [],
                                context, (value) {
                              setState(() {
                                extrasList.addAll(value);
                                totalSparePartsPrice = 0;
                                widget.viewModel!
                                    .addExtraToTotal(value, widget.item);
                              });
                            }, (value) => value.getName(),
                                (value) => value.price, null)),
                    const Divider(
                      thickness: 0.7,
                    ),
                    AddingAdditionalInformationWidget(
                      icon: Icons.note_add_outlined,
                      title: strings.getStrings(AllStrings.addNoteTitle),
                      onTap: () {
                        setState(() {
                          noteVisible = !noteVisible;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    !noteVisible
                        ? const SizedBox()
                        : Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          noteVisible = !noteVisible;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.grey,
                                        size: 18,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              PrimaryTextFieldWithHeader(
                                  isObscure: false,
                                  hintText:
                                      strings.getStrings(AllStrings.noteTitle),
                                  initialValue: widget.item.additionalNotes,
                                  isEditable: true,
                                  onChangedValue: (value) {
                                    setState(() {
                                      note = value;
                                      widget.viewModel!.updateItemDetails(
                                          widget.item,
                                          defaultDimensions,
                                          defaultThickness,
                                          defaultColor,
                                          defaultMotor,
                                          note);
                                    });
                                  },
                                  inputType: InputType.longText),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                    note != null && note!.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                strings.getStrings(AllStrings.noteTitle),
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                note!,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        : const SizedBox(),
                  ],
                )
              : const SizedBox(),
          const Divider(
            thickness: 0.7,
          ),
        ],
      ),
    );
  }
}

void selectExtrasBottomSheet<T>(
  List<T>? list,
  BuildContext context,
  void Function(List<T> data) returnData,
  String Function(T model) titleSelector,
  double Function(T model) priceSelector,
  Widget Function(T model)? imageSelector,
) {
  showModalBottomSheet(
      context: context,
      builder: (context) => MultiSelectList<T>(
          items: list ?? [],
          selectedItems: (value) => returnData(value),
          titleSelector: titleSelector,
          priceSelector: priceSelector,
          imageSelector: imageSelector));
}

void openPopUpDialogForAddingExtras(
  BuildContext context,
  String headerTitle,
  void Function(ExtraModel extrasModel) addExtras,
) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
              child: AddExtraAlertDialog(
            headTitle: headerTitle,
            addExtras: addExtras,
          )));
}

void openBottomSheet(
  List<String?> list,
  BuildContext context,
  AllStrings header,
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
                  "${string.getStrings(AllStrings.enterTitle)} ${string.getStrings(header)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const Divider(
              thickness: 0.7,
            ),
            header == AllStrings.dimensionsTitle
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${string.getStrings(AllStrings.enterTitle)} ${string.getStrings(header)}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                        EnterDimensionsManuallyWidget(
                            returnDimensions: returnData)
                      ],
                    ),
                  )
                : const SizedBox(),
            Column(
              children: list
                  .map((e) => ListTile(
                        onTap: () => returnData(e!),
                        title: Text(e.toString()),
                      ))
                  .toList(),
            ),
          ],
        )),
  );
}

void openBottomSheetForMotors(
  List<Motor?> list,
  BuildContext context,
  AllStrings header,
  void Function(Motor data) returnData,
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
                  "${string.getStrings(AllStrings.enterTitle)} ${string.getStrings(header)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            const Divider(
              thickness: 0.7,
            ),
            header == AllStrings.dimensionsTitle
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${string.getStrings(AllStrings.enterTitle)} ${string.getStrings(header)}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            if (list.isNotEmpty)
              Column(
                children: list
                    .map((e) => ListTile(
                          onTap: () => returnData(e),
                          title: Text(e!.getMotorName().toString()),
                        ))
                    .toList(),
              ),
          ],
        )),
  );
}
