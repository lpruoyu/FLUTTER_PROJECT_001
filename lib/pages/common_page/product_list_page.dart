import 'dart:convert';

import 'package:b2c_shop/models/product_list.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/utils/Api.dart';
import 'package:b2c_shop/utils/Network.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/*
    商品列表
 */
class ProductListPage extends StatefulWidget {
  final Map arguments;

  ProductListPage({@required this.arguments});

  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends State<ProductListPage> {
  String search;

  int pageIndex = 1;

  final int pageSize = 10;

  bool isLoading = true;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    search = widget.arguments["search"];
    _listController = ScrollController();
    _listController.addListener(() {
      if (hasMore) {
        if (_listController.position.pixels >=
            _listController.position.maxScrollExtent - 20) {
          requestProductListData();
        }
      }
    });
    requestProductListData();
  }

  List<ProductListItemModel> productDataList = [];

  void requestProductListData() async {
    if (hasMore) {
      if (isLoading) {
        isLoading = false;
        String productStr;
        if (search == null) {
          productStr = await NetworkRequest.getDataFuture(productList +
              "?cid=${widget.arguments["cid"]}&pageSize=$pageSize&page=$pageIndex&sort=$_sort");
        } else {
          productStr = await NetworkRequest.getDataFuture(productList +
              "?search=$search&pageSize=$pageSize&page=$pageIndex&sort=$_sort");
        }
        ProductListModel productRes =
            ProductListModel.fromJson(json.decode(productStr));
        var res = productRes.result;
        if (res.length < pageSize) {
          hasMore = false;
        }
        setState(() {
          productDataList.addAll(productRes.result);
        });
        isLoading = true;
        pageIndex++;
      }
    }
  }

  int currentSelectedTitle = 1;

  /*二级导航数据*/
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
          -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];

  String _sort = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "${widget.arguments["title"] == null ? "商品列表" : widget.arguments["title"]}"),
      ),
      body: _body(),
    );
  }

  final double titleBarHeight = SC.SH() / 14;

  void titleIndexChange(id) {
    if (id == 4) return;

    pageIndex = 1;

    isLoading = true;

    hasMore = true;

    productDataList = [];

    if (id == 2 || id == 3) {
      _subHeaderList[id - 1]["sort"] = -(_subHeaderList[id - 1]["sort"]);
      _sort =
          "${_subHeaderList[id - 1]["fileds"]}_${_subHeaderList[id - 1]["sort"]}";
    } else if (id == 1) {
      _sort = "";
    }

    requestProductListData();
  }

  Widget _topTitleBar() {
    return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      height: titleBarHeight,
      child: Row(
        children: _subHeaderList
            .map((v) => Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        currentSelectedTitle = v["id"];
                        titleIndexChange(v["id"]);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            v["title"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: currentSelectedTitle == v["id"]
                                    ? Colors.red
                                    : Colors.black),
                          ),
                          v["id"] == 2 || v["id"] == 3
                              ? (v["sort"] > 0
                                  ? Icon(Icons.arrow_drop_up)
                                  : Icon(Icons.arrow_drop_down))
                              : Text(""),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  ScrollController _listController;

  Widget _productListWidget() {
    return Container(
      width: SC.SW(),
      margin: EdgeInsets.only(top: titleBarHeight),
      child: productDataList.length > 0
          ? ListView.builder(
              controller: _listController,
              itemBuilder: (context, index) =>
                  index == productDataList.length - 1
                      ? Column(
                          children: <Widget>[
                            productInfoWidget(index),
                            hasMore
                                ? Loading()
                                : Container(
                                    child: Text("- - - > 我是有底线的 < - - -"),
                                    padding: EdgeInsets.only(
                                        top: SC.H(10), bottom: SC.H(30)),
                                  )
                          ],
                        )
                      : productInfoWidget(index),
              itemCount: productDataList.length,
            )
          : Loading(),
    );
  }

  Widget productInfoWidget(index) => InkWell(
        child: Container(
          width: SC.SW(),
          height: SC.SH() / 5.2,
          padding: EdgeInsets.all(SC.W(20)),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      child: AspectRatio(
                        child: Image.network(
                          domain +
                              productDataList[index].pic.replaceAll("\\", "/"),
                          fit: BoxFit.cover,
                        ),
                        aspectRatio: 1,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding:
                            EdgeInsets.only(left: SC.W(20), right: SC.W(20)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              productDataList[index].title,
                              maxLines: 2,
                            ),
                            Row(
                              children: <Widget>[
                                _productTag("优质"),
                                _productTag("好评"),
                              ],
                            ),
                            Text(
                              "￥${productDataList[index].price}",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: SC.H(20),
              ),
              Divider(
                height: SC.H(1),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, ConfigRoute.PRODUCT_DETAILS,
              arguments: {"id": productDataList[index].sId});
        },
      );

  Widget _productTag(String title) => Container(
        margin: EdgeInsets.only(right: SC.W(12)),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color.fromRGBO(233, 233, 233, 0.9)),
        child: Text(
          title,
          style: TextStyle(fontSize: 11),
          textAlign: TextAlign.center,
        ),
        width: SC.W(100),
        padding: EdgeInsets.only(top: SC.H(8), bottom: SC.H(8)),
      );

  Widget _body() {
    return Container(
      child: Stack(
        children: <Widget>[
          _productListWidget(),
          _topTitleBar(),
        ],
      ),
    );
  }
}
