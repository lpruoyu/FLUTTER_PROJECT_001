import 'dart:convert';

import 'package:b2c_shop/models/product_details.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/pages/product_details/details_page.dart';
import 'package:b2c_shop/pages/product_details/evaluate_page.dart';
import 'package:b2c_shop/pages/product_details/product_page.dart';
import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/utils/Api.dart';
import 'package:b2c_shop/utils/Network.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';

class ProductDetailsPage extends StatefulWidget {
  final Map arguments;

  ProductDetailsPage({@required this.arguments});

  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends State<ProductDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabBarController;

  ProductDetailsItem _productDetailsItem;

  @override
  void initState() {
    super.initState();
    _tabBarController = TabController(vsync: this, length: 3);
    requestData();
  }

  void requestData() async {
    var apiUrl = productDetails + widget.arguments["id"];

    var dataRes = await NetworkRequest.getDataFuture(apiUrl);

    var decode = json.decode(dataRes);

    var productDetailsModel = ProductDetailsModel.fromJson(decode).result;

    setState(() {
      _productDetailsItem = productDetailsModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    double stateBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: SC.SW(),
      height: SC.SH(),
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              // appBar
              padding: EdgeInsets.only(top: stateBarHeight),
              width: SC.SW(),
              height: kToolbarHeight + stateBarHeight,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        width: SC.SW() / 3 * 2,
                        child: TabBar(
                          controller: _tabBarController,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: Colors.red,
                          tabs: <Widget>[
                            Text(
                              "商品",
                              style: tabTextStyle,
                            ),
                            Text(
                              "详情",
                              style: tabTextStyle,
                            ),
                            Text(
                              "评价",
                              style: tabTextStyle,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      _showMenu();
                    },
                  ),
                ],
              ),
            ),
            _productDetailsItem == null
                ? Loading()
                : Expanded(
                    /// Body
                    flex: 1,
                    child: Container(
                      color: Colors.white70,
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _tabBarController,
                        children: <Widget>[
                          ProductPage(_productDetailsItem),
                          DetailPage(_productDetailsItem),
                          EvaluatePage()
                        ],
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  var tabTextStyle = TextStyle(
      color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16.0);

  void _showMenu() async {
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(SC.SW() / 3,
            MediaQuery.of(context).padding.top + kToolbarHeight, 0, 0),
        items: [
          PopupMenuItem(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Icon(Icons.home),
                  SizedBox(
                    width: SC.W(20),
                  ),
                  Text("首页")
                ],
              ),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, ConfigRoute.HOME, (v) => v == null);
              },
            ),
          ),
          PopupMenuItem(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Icon(Icons.search),
                  SizedBox(
                    width: SC.W(20),
                  ),
                  Text("搜索")
                ],
              ),
              onTap: () {
                Navigator.pushReplacementNamed(context, ConfigRoute.SEARCH);
              },
            ),
          ),
        ]);
  }
}
