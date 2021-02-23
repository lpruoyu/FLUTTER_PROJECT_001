import 'dart:convert';

import 'package:b2c_shop/models/product_details.dart';
import 'package:b2c_shop/utils/SharedPreferences.dart';
import 'package:flutter/material.dart';

class ShoppingCartProvider with ChangeNotifier {
  List<ProductDetailsItem> _dataList = [];

  ShoppingCartProvider() {
    initData();
  }

  void addData(ProductDetailsItem item) {
    String info = formatCartData(item);
    _addData(info);
  }

  List<ProductDetailsItem> getDataList() {

    return _dataList;
  }

  void clearData() async {
    await SharedPreferencesUtil.clearHistoryData(KEY_SHOPPING_CART);
    initData();
  }

  void removeData(ProductDetailsItem item) async {
    String info = formatCartData(item);
    await SharedPreferencesUtil.removeHistoryDataShoppingCart(
        KEY_SHOPPING_CART, info);
    initData();
  }

  void _addData(String data) async {
    await SharedPreferencesUtil.addHistoryDataShoppingCart(
        KEY_SHOPPING_CART, data);
    initData();
  }

  void initData() async {
    var historyDataList =
        await SharedPreferencesUtil.getHistoryDataList(KEY_SHOPPING_CART);
    _dataList.clear();
    if (historyDataList.length > 0) {
      historyDataList.forEach((v) {
        v = json.decode(v);
        _dataList.add(toItem(v));
      });
    }
    notifyListeners();
  }

  static String formatCartData(ProductDetailsItem item) {
    final Map data = new Map<String, dynamic>();
    data['_id'] = item.sId;
    data['title'] = item.title;
    data['price'] = item.price;
    data['count'] = item.count;
    data['pic'] = item.pic;
    data['checked'] = true;
    return json.encode(data);
  }

  ProductDetailsItem toItem(Map v) {
    ProductDetailsItem pi = new ProductDetailsItem();
    pi.sId = v['_id'];
    pi.title = v['title'];
    pi.price = v['price'];
    pi.count = v['count'];
    pi.checked = v["checked"];
    pi.pic = v["pic"];
    return pi;
  }
}
