import 'dart:convert';

import 'package:e3tmed/logic/interfaces/ICart.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/order.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cart implements ICart {
  final _cartListStream = BehaviorSubject<List<OrderItem>?>.seeded(null);
  late List<OrderItem> _cartList;
  late Future initFuture;
  bool isUsed = false;

  Cart() {
    initFuture = init();
  }

  Future<void> init() async {
    _cartListStream.add(null);
    final pref = await SharedPreferences.getInstance();
    final orderItemFactory =
        Injector.appInstance.get<IModelFactory<OrderItem>>();
    final cartString = pref.getString("cart");
    if (cartString != null) {
      try {
        _cartList = jsonDecode(cartString)
            .map<OrderItem>((u) => orderItemFactory.fromJson(u))
            .toList();
      } catch (e) {
        _cartList = [];
      }
    } else {
      _cartList = [];
    }
    _cartListStream.add(_cartList);
  }

  Future<void> save() async {
    await Future.wait([initFuture]);
    final pref = await SharedPreferences.getInstance();
    await pref.setString(
        "cart", jsonEncode(_cartList.map((e) => e.toJson()).toList()));
  }

  @override
  Future<List<OrderItem>> getAllItemsFromCartDB() async {
    await Future.wait([initFuture]);
    return _cartList;
  }

  @override
  Future<bool> insertItemIntoCartDB(OrderItem orderItem) async {
    await Future.wait([initFuture]);
    _cartList.add(orderItem);
    _cartListStream.add(null);
    await save();
    _cartListStream.add(_cartList);
    return true;
  }

  @override
  Future<bool> deleteItemFromCartDB(OrderItem orderItem) async {
    await Future.wait([initFuture]);
    final res = _cartList.remove(orderItem);
    _cartListStream.add(null);
    await save();
    _cartListStream.add(_cartList);
    return res;
  }

  @override
  Stream<List<OrderItem>?> get carList => _cartListStream;

  @override
  void checkoutCallback() async {
    if (isUsed) {
      isUsed = false;
      _cartList.clear();
      _cartListStream.add(null);
      await save();
      _cartListStream.add(_cartList);
    }
  }

  @override
  void setCartUsed(bool isUsed) {
    this.isUsed = isUsed;
  }
}
