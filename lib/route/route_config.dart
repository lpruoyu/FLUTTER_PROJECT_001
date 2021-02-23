import 'package:b2c_shop/pages/common_page/product_list_page.dart';
import 'package:b2c_shop/pages/product_details/pd_main.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:b2c_shop/index.dart';
import 'package:b2c_shop/pages/common_page/search.dart';
import 'package:b2c_shop/route/route_toggle_anim.dart';
import 'package:b2c_shop/utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigRoute {

  static const String HOME = "/";

  // HOME配置主页面
  static const String SEARCH = "/SEARCH";
  static const String PRODUCT_LIST = "/PRODUCT_LIST";
  static const String PRODUCT_DETAILS = "/PRODUCT_DETAILS";

  // 配置路由
  static final Map<String, Function> pageConfigs = {
    SEARCH: () => SearchPage(),
    PRODUCT_LIST: (arguments) => ProductListPage(arguments: arguments),
    PRODUCT_DETAILS: (arguments) => ProductDetailsPage(arguments: arguments)
  };

// 主页面
  static final Map<String, WidgetBuilder> mainRoute = {
    HOME: (context) {
      SC.init(context);// 初始化屏幕适配工具类
      return MainApp();
    }
  };

// 路由生成器
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Function pageBuilderFunc = pageConfigs[settings.name];
    if (pageBuilderFunc == null) throw Exception("路由${settings.name}未进行配置！");
    if (settings.arguments == null) {
      return RoutePageBuilderAnim(pageBuilderFunc());
    } else {
      return RoutePageBuilderAnim(pageBuilderFunc(settings.arguments));
    }
  }

}
