import 'package:b2c_shop/pages/features/home/main_page.dart';
import 'package:b2c_shop/pages/features/category/main_page.dart';
import 'package:b2c_shop/pages/features/my/main_page.dart';
import 'package:b2c_shop/pages/features/shopping_cart/main_page.dart';
import 'package:b2c_shop/style/main_style.dart';
import 'package:b2c_shop/utils/SharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends State<MainApp> {
  int _currentIndex = 0;

  /*
      底部四个按钮
   */
  final List<BottomNavigationBarItem> _mBtmBars = [
    BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
    BottomNavigationBarItem(icon: Icon(Icons.category), title: Text("分类")),
    BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart), title: Text("购物车")),
    BottomNavigationBarItem(
        icon: Icon(Icons.account_circle), title: Text("我的")),
  ];

  /*
    四个页面
  */
  List<Widget> _mBody;

  PageController _pageController;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    initBody();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: _mBody,
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.brown,
        unselectedItemColor: bottomUnSelectedColor,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.jumpToPage(_currentIndex);
        },
        items: _mBtmBars,
        currentIndex: _currentIndex,
      ),
    );
  }

  void initBody() {
    _mBody = [
      HomePage(),
      CategoryPage(),
      ShoppingCartPage(),
      MyPage(),
    ];
  }

}
