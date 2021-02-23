import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String KEY_HISTORY = "history";

const String KEY_SHOPPING_CART = "shopping_cart";

class SharedPreferencesUtil {

  static void addListData(String key, String keywords) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, keywords);
  }

  static void addHistoryData(String key, String keywords) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (isEmpty(string)) {
      List list = [];
      list.add(keywords);
      sp.setString(key, json.encode(list));
    } else {
      List list = json.decode(string);
      if (!(list.any((v) => v == keywords))) {
        list.insert(0, keywords);
        sp.setString(key, json.encode(list));
      }
    }
  }

  static void addHistoryDataShoppingCart(String key, String keywords) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (isEmpty(string)) {
      List list = [];
      list.add(keywords);
      sp.setString(key, json.encode(list));
    } else {
      List list = json.decode(string);
      if (!(list.any((v) {
        var decode = json.decode(keywords);
        Map val = json.decode(v);
        return (val["_id"] == decode["_id"]);
      }))) {
        list.insert(0, keywords);
      } else {
        var decode = json.decode(keywords);
        for (int i = 0; i < list.length; i++) {
          Map v = json.decode(list[i]);
          if (v["_id"] == decode["_id"]) {
            v["count"] = v["count"] + 1;
            list[i] = json.encode(v);
          }
        }
      }
      sp.setString(key, json.encode(list));
    }
  }

  static void removeHistoryData(String key, String keywords) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (!isEmpty(string)) {
      List list = json.decode(string);
      list.remove(keywords);
      sp.setString(key, json.encode(list));
    }
  }

  static void removeHistoryDataShoppingCart(String key, String keywords) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (!isEmpty(string)) {
      List list = json.decode(string);
      for (int i = 0; i < list.length; i++) {
        Map v = json.decode(list[i]);
        if (v["count"] == 1) {
          list.remove(keywords);
        } else {
          v["count"] = v["count"] - 1;
          list[i] = json.encode(v);
        }
      }
      sp.setString(key, json.encode(list));
    }
  }

  static Future<bool> clearHistoryData(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (!isEmpty(string)) {
      return await sp.setString(key, "");
    }
    return false;
  }

  static Future<List> getHistoryDataList(String key) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var string = sp.getString(key);
    if (!isEmpty(string)) {
      return json.decode(string);
    } else {
      return [];
    }
  }
}

bool isEmpty(String value) => value == null || value == "";
