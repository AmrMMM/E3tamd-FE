// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/product_card_item.dart';
import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/product.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/product_list_viewmodel.dart';
import '../settings/settings_screen.dart';

class ProductListScreenArgs {
  final Category category;
  final bool maintenanceMode;

  ProductListScreenArgs(
      {required this.category, required this.maintenanceMode});
}

class ProductListScreen extends ScreenWidget {
  ProductListScreen(BuildContext context) : super(context);

  @override
  ProductListState createState() => ProductListState(context);
}

class ProductListState extends BaseStateArgumentObject<ProductListScreen,
    ProductListViewModel, ProductListScreenArgs> {
  ProductListState(BuildContext context)
      : super(() => ProductListViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  Category? groupValue;
  late String dropDownHint = strings.getStrings(AllStrings.allTitle);
  Category? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args!.category.getName()),
      ),
      body: Directionality(
        textDirection: useLanguage == Languages.arabic.name
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<bool>(
              stream: viewModel.showScreen,
              initialData: false,
              builder: (context, snapshot) {
                if (!snapshot.data!) {
                  return const Center(child: MainLoadinIndicatorWidget());
                }
                return Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder<List<Category>?>(
                        stream: viewModel.topSwitchItems,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: MainLoadinIndicatorWidget(),
                            );
                          }
                          if (snapshot.data!.isEmpty) {
                            return Container();
                          }
                          return Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SizedBox(
                                      width: double.infinity,
                                      child: Material(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          elevation: 5,
                                          child:
                                              CupertinoSlidingSegmentedControl<
                                                  Category>(
                                            backgroundColor: Colors.white,
                                            thumbColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            children: {
                                              for (var u in snapshot.data!)
                                                u: segment(u.getName())
                                            },
                                            onValueChanged: (value) {
                                              if (value == null) return;
                                              setState(() {
                                                groupValue = value;
                                              });
                                              viewModel
                                                  .setTopSwitchCategory(value);
                                            },
                                            groupValue:
                                                groupValue ?? snapshot.data![0],
                                          )))),
                              const SizedBox(
                                height: 5,
                              ),
                            ],
                          );
                        }),
                    StreamBuilder<List<Category>?>(
                        stream: viewModel.filterItems,
                        builder: (context, snapshot) {
                          return snapshot.data != null &&
                                  snapshot.data!.isNotEmpty
                              ? Column(
                                  children: [
                                    Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: CupertinoColors.systemBlue,
                                            boxShadow: const [
                                              BoxShadow(color: Colors.black38)
                                            ]),
                                        child: DropdownButton<Category?>(
                                          elevation: 5,
                                          isDense: false,
                                          underline: const SizedBox(),
                                          selectedItemBuilder: (context) => [
                                            ...(snapshot.data
                                                    ?.map((e) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          dropDownHint,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                          textAlign:
                                                              TextAlign.center,
                                                        )))
                                                    .toList() ??
                                                []),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Center(
                                                  child: Text(
                                                    strings.getStrings(
                                                        AllStrings.allTitle),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ))
                                          ],
                                          hint: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              dropDownHint,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          disabledHint:
                                              const MainLoadinIndicatorWidget(),
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          items: [
                                            ...(snapshot.data
                                                    ?.map((e) =>
                                                        DropdownMenuItem<
                                                            Category>(
                                                          value: e,
                                                          child: Text(
                                                            e.getName(),
                                                            style: const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 12),
                                                          ),
                                                        ))
                                                    .toList() ??
                                                []),
                                            DropdownMenuItem<Category>(
                                              value: null,
                                              child: Text(
                                                strings.getStrings(
                                                    AllStrings.allTitle),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              dropDownHint = value?.getName() ??
                                                  strings.getStrings(
                                                      AllStrings.allTitle);
                                              selectedFilter = value;
                                            });
                                            viewModel.setFilterCategory(value);
                                          },
                                          value: selectedFilter,
                                        )),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                )
                              : const SizedBox();
                        }),
                    Expanded(
                      child: StreamBuilder<List<Product>?>(
                          stream: viewModel.itemsList,
                          builder: (context, snapshot) => snapshot.data == null
                              ? Center(
                                  child: MainLoadinIndicatorWidget(
                                    hasColor: Theme.of(context).primaryColor,
                                  ),
                                )
                              : ListView(
                                  children: snapshot.data!
                                      .map((e) => ProductCardItemWidget(
                                          product: e,
                                          onTap:
                                              viewModel.navigateToItemDetails))
                                      .toList(),
                                )),
                    )
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget segment(String name) => Text(
        name,
        style: const TextStyle(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
      );
}
