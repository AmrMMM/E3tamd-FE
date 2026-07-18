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
  Category? _selectedFilterCategory; // null means "All"

  Stream<List<Product>?> get itemsList => _itemsList;

  Stream<List<Category>?> get topSwitchItems => _topSwitchItems;

  Stream<List<Category>?> get filterItems => _filterItems;

  Stream<bool> get showScreen => _showScreen;

  /// A maintenance category owns no products; it points (maintenanceCategoryId)
  /// at the category whose products it maintains. Queries use the resolved id
  /// so a maintenance child tab shows the referenced sibling's products.
  Category _dataCategoryFor(Category c) => c.maintenanceCategoryId == null
      ? c
      : Category(
          id: c.maintenanceCategoryId!,
          nameAr: c.nameAr,
          nameEn: c.nameEn,
          maintenanceCategoryId: null);

  void _init() async {
    try {
      final topSwitchItems = await logic.getChildrenOf(args!.category);
      if (topSwitchItems.isNotEmpty) {
        _selectedTopCategory = topSwitchItems[0];
        _topSwitchItems.add(topSwitchItems);
        _filterItems.add(
            await logic.getChildrenOf(_dataCategoryFor(_selectedTopCategory!)));
      } else {
        _topSwitchItems.add([]);
      }
      _showScreen.add(true);
      await _loadProducts();
    } catch (e) {
      // Transport gave up (bounded retries exhausted): surface it on the outer
      // gate so the screen shows an error + retry instead of spinning forever.
      _showScreen.addError(e);
    }
  }

  void retryInit() {
    _showScreen.add(false);
    _topSwitchItems.add(null);
    _filterItems.add(null);
    _itemsList.add(null);
    _init();
  }

  Future<void> _loadProducts() async {
    try {
      _itemsList.add(await logic.getProductsOf(_selectedFilterCategory ??
          _dataCategoryFor(_selectedTopCategory ?? args!.category)));
    } catch (e) {
      _itemsList.addError(e);
    }
  }

  void retryProducts() {
    _itemsList.add(null);
    _loadProducts();
  }

  void setTopSwitchCategory(Category category) async {
    _itemsList.add(null);
    _filterItems.add(null);
    _selectedTopCategory = category;
    _selectedFilterCategory = null;
    await _loadProducts();
    try {
      _filterItems.add(
          await logic.getChildrenOf(_dataCategoryFor(_selectedTopCategory!)));
    } catch (e) {
      // The filter row is optional chrome; don't leave it spinning forever.
      _filterItems.add([]);
    }
  }

  void setFilterCategory(Category? category) async {
    _itemsList.add(null);
    _selectedFilterCategory = category;
    await _loadProducts();
  }

  void navigateToItemDetails(Product product) {
    Navigator.pushNamed(context, "/itemDetails",
        arguments: ItemDetailsScreenArgs(
            product: product,
            maintenanceMode: args!.maintenanceMode ||
                (_selectedTopCategory?.maintenanceCategoryId != null)));
  }
}
