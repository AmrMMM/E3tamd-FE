import 'dart:typed_data';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/custom_dotted_border/custom_dotted_border.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/common/image_widgets/product_image.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:photo_view/photo_view.dart';

import '../../../../DI.dart';
import '../../../../common/buttons/primarybuttonshape.dart';
import '../../../../common/buttons/secondary_icon_button.dart';
import '../../../../common/quantity_counter/quantity_counter.dart';
import '../../../../viewmodels/end_user_viewmodels/item_details_view_model.dart';
import 'add_dimensions.dart';
import 'extra_photo_widget.dart';

class ItemDetailsScreenArgs {
  final Product product;
  final bool maintenanceMode;

  ItemDetailsScreenArgs({
    required this.product,
    required this.maintenanceMode,
  });
}

class ItemDetailsScreen extends ScreenWidget {
  ItemDetailsScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  ItemDetailsScreenState createState() => ItemDetailsScreenState(context);
}

class ItemDetailsScreenState extends BaseStateArgumentObject<ItemDetailsScreen,
    ItemDetailsViewModel, ItemDetailsScreenArgs> {
  ItemDetailsScreenState(BuildContext context)
      : super(() => ItemDetailsViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  int quantity = 1;
  String notes = "";
  List<Uint8List>? photosList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(args!.product.getCategoryName()),
        ),
        body: Directionality(
          textDirection:
              useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
          child: Center(
              child: ListView(
            children: [
              Container(
                key: const Key("loading"),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Material(
                  elevation: 0.7,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductImage(
                      product: args!.product,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flex(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      direction: Axis.horizontal,
                      children: [
                        Flexible(
                          child: Text(
                            args!.product.getProductName(),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Text(
                              args!.product.getCategoryName(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        args!.product.description,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    if (!args!.product.withExtraDetails) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          "${(args!.product.basePrice * quantity).toString()} SAR",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      QuantityCounter(
                          max: args!.product.stock,
                          onQuantityChange: (value) {
                            setState(() {
                              quantity = value;
                            });
                          }),
                    ],
                    if (args!.maintenanceMode)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SecondaryIconButtonShape(
                                width: 150,
                                iconData: Icons.camera_alt_outlined,
                                text: strings
                                    .getStrings(AllStrings.addPhotoTitle),
                                clickable: true,
                                color: Theme.of(context).colorScheme.secondary,
                                stream: null,
                                onTap: () async {
                                  var image =
                                      await viewModel.pickImageFromGallery();
                                  if (image != null) {
                                    setState(() {
                                      photosList?.add(image);
                                    });
                                  }
                                }),
                            if ((photosList ?? []).isNotEmpty)
                              Container(
                                height: 110,
                                width: double.infinity,
                                decoration: const BoxDecoration(),
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: photosList!
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ExtraPhotoWidget(
                                              imageData: e,
                                              isRemovable: true,
                                              removeImage: (imageData) =>
                                                  setState(() {
                                                photosList!.remove(imageData);
                                              }),
                                              previewImage: (imageData) =>
                                                  showPopUpDialog(
                                                      context, imageData),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              )
                          ],
                        ),
                      ),
                    const SizedBox(
                      height: 5,
                    ),
                    if (args!.product.withExtraDetails &&
                        !args!.maintenanceMode) ...[
                      CustomDottedBorderWidget(
                        message: strings.getStrings(AllStrings
                            .ifYouDontKnowTheDoorDimensionsYouCanAskForAnAgentTitle),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                    if (args!.maintenanceMode)
                      PrimaryTextFieldWithHeader(
                          isObscure: false,
                          onChangedValue: (val) {
                            notes = val;
                          },
                          hintText: strings.getStrings(AllStrings.addNoteTitle),
                          inputType: InputType.longText),
                    PrimaryButtonShape(
                        width: double.infinity,
                        text: args!.product.withExtraDetails
                            ? strings.getStrings(AllStrings.askForAgentTitle)
                            : strings
                                .getStrings(AllStrings.continueCheckoutTitle),
                        color: Theme.of(context).colorScheme.secondary,
                        stream: null,
                        onTap: args!.product.withExtraDetails
                            ? (() => viewModel.navigateToCheckoutForAgent(
                                notes, photosList))
                            : (() => viewModel.navigateToCheckout(notes, null,
                                null, null, null, [], quantity, photosList))),
                    if (!args!.product.withExtraDetails ||
                        args!.maintenanceMode)
                      PrimaryButtonShape(
                          width: double.infinity,
                          text: strings.getStrings(AllStrings.addToCartTitle),
                          color: Theme.of(context).colorScheme.secondary,
                          stream: null,
                          onTap: () => viewModel.addToCart(
                              args!.product,
                              notes,
                              null,
                              null,
                              null,
                              null,
                              [],
                              quantity,
                              photosList)),
                    if (args!.product.withExtraDetails &&
                        !args!.maintenanceMode) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              strings.getStrings(AllStrings.itemDetailsTitle),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 13),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                      const Divider(
                        thickness: 0.7,
                      ),
                      AddDimensionsWidget(
                        navigateToCheckout:
                            (dimension, thickness, color, motor, extras) =>
                                viewModel.navigateToCheckout(
                                    notes,
                                    dimension,
                                    thickness,
                                    color,
                                    motor,
                                    extras,
                                    quantity,
                                    photosList),
                        addToCart: (product, dimension, thickness, color, motor,
                                extras) =>
                            viewModel.addToCart(
                                product,
                                notes,
                                dimension,
                                thickness,
                                color,
                                motor,
                                extras,
                                quantity,
                                photosList),
                        motors: args?.product.motors ?? [],
                        priceStream: viewModel.totalPrice,
                        calculatePrice: viewModel.calculatePrice,
                        product: args!.product,
                      )
                    ],
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          )),
        ));
  }

  void showPopUpDialog(BuildContext context, Uint8List image) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return PhotoView(
            enableRotation: true,
            filterQuality: FilterQuality.high,
            backgroundDecoration:
                const BoxDecoration(color: Colors.transparent),
            imageProvider: MemoryImage(image),
          );
        });
  }
}
