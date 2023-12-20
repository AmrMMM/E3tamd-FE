import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/interfaces/core_logic.dart';
import '../../screens/end_user_phase/home/product_list_screen.dart';
import '../../screens/end_user_phase/requesting_item_screen/item_details_screen/item_details_screen.dart';

class ProductListViewModel
    extends BaseViewModelWithLogicAndArgs<ICoreLogic, ProductListScreenArgs> {
  ProductListViewModel(BuildContext context) : super(context);

  @override
  void onArgsPushed() {
    _init();
  }

  final _itemsList = BehaviorSubject<List<Product>?>.seeded(null);
  final _topSwitchItems = BehaviorSubject<List<Category>?>.seeded(null);
  final _filterItems = BehaviorSubject<List<Category>?>.seeded(null);
  final _showScreen = BehaviorSubject<bool>.seeded(false);
  Category? _selectedTopCategory;

  Stream<List<Product>?> get itemsList => _itemsList;

  Stream<List<Category>?> get topSwitchItems => _topSwitchItems;

  Stream<List<Category>?> get filterItems => _filterItems;

  Stream<bool> get showScreen => _showScreen;

  void _init() async {
    final topSwitchItems = await logic.getChildrenOf(args!.category);
    if (topSwitchItems.isNotEmpty) {
      _selectedTopCategory = topSwitchItems[0];
      _topSwitchItems.add(topSwitchItems);
      _filterItems.add(await logic.getChildrenOf(_selectedTopCategory!));
    } else {
      _topSwitchItems.add([]);
    }
    _showScreen.add(true);
    _itemsList
        .add(await logic.getProductsOf(_selectedTopCategory ?? args!.category));
  }

  void setTopSwitchCategory(Category category) async {
    _itemsList.add(null);
    _filterItems.add(null);
    _selectedTopCategory = category;
    _itemsList.add(await logic.getProductsOf(category));
    _filterItems.add(await logic.getChildrenOf(_selectedTopCategory!));
  }

  void setFilterCategory(Category? category) async {
    _itemsList.add(null);
    _itemsList
        .add(await logic.getProductsOf(category ?? _selectedTopCategory!));
  }

  void navigateToItemDetails(Product product) {
    Navigator.pushNamed(context, "/itemDetails",
        arguments: ItemDetailsScreenArgs(
            product: product, maintenanceMode: args!.maintenanceMode));
  }
}
