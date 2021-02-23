import 'package:b2c_shop/models/product_details.dart';
import 'package:b2c_shop/pages/base_page.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/utils/Api.dart';

import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:b2c_shop/utils/SharedPreferences.dart';
import 'package:b2c_shop/utils/ShoppingCartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShoppingCartPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends BaseStateWithScaffold<ShoppingCartPage> {
  bool allChecked = false;

  List<ProductDetailsItem> dataList;

  bool isLoading = true;

  void getData() async {
    if (isLoading) {
      isLoading = false;
      setState(() {
        dataList = Provider.of<ShoppingCartProvider>(context).getDataList();
      });
      isLoading = true;
    }
  }

  @override
  Widget createWidget() {
    getData();

    var _bottomHeight = SC.SH() / 16;

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("购物车"),
        ),
        body: Container(
          color: Colors.white70,
          child: Stack(
            children: <Widget>[
              Container(
                child: Container(
                  color: Colors.white12,
                  padding: EdgeInsets.all(SC.W(20)),
                  child: ListView(
                    children: dataList == null
                        ? [Loading()]
                        : dataList.map((v) => _productListTile(v)).toList(),
                  ),
                ),
                margin: EdgeInsets.only(bottom: _bottomHeight),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black12))),
                  width: SC.SW(),
                  height: _bottomHeight + SC.H(15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Positioned(
                        left: SC.W(30),
                        child: Checkbox(
                          activeColor: Colors.pink,
                          value: allChecked,
                          onChanged: (v) {
                            setState(() {
                              allChecked = v;
                              if (null != dataList) {
                                setState(() {
                                  if (allChecked) {
                                    dataList.forEach((value) {
                                      value.checked = true;
                                    });
                                  } else {
                                    dataList.forEach((value) {
                                      value.checked = false;
                                    });
                                  }
                                });
                              }
                            });
                          },
                        ),
                      ),
                      Positioned(
                        left: SC.W(130),
                        child: InkWell(
                          child: Text(
                            "全选",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17.0),
                          ),
                          onTap: () {
                            setState(() {
                              allChecked = !allChecked;
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: SC.W(30),
                        child: InkWell(
                          child: Container(
                            alignment: Alignment.center,
                            child: Text(
                              "立即购买",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            height: _bottomHeight - SC.H(8),
                            width: SC.SW() / 3,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(253, 1, 0, 0.9),
                                borderRadius: BorderRadius.circular(SC.W(15))),
                          ),
                          onTap: _buy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // 立即购买
  void _buy() {}

  @override
  String getTitle() => "shopping cart";

  Widget _productListTile(ProductDetailsItem valueItem) => Card(
        margin: EdgeInsets.only(bottom: SC.H(10)),
        child: Container(
          width: SC.SW(),
          height: SC.SH() / 6,
          child: Row(
            children: <Widget>[
              Container(
                child: Checkbox(
                  activeColor: Colors.pink,
                  value: valueItem.checked,
                  onChanged: (v) {
                    setState(() {
                      valueItem.checked = !valueItem.checked;
                    });
                  },
                ),
                margin: EdgeInsets.all(SC.W(5)),
              ),
              Container(
                padding: EdgeInsets.all(SC.W(10)),
                child: AspectRatio(
                  child: Image.network(
                    "${domain + valueItem.pic.replaceAll('\\', '/')}",
                    fit: BoxFit.cover,
                  ),
                  aspectRatio: 1,
                ),
                height: SC.SH() / 6 - SC.W(30),
              ),
              SizedBox(
                width: SC.W(10),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: EdgeInsets.only(top: SC.H(8), bottom: SC.H(8)),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            "${valueItem.title}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "￥${valueItem.price}",
                                style: TextStyle(
                                    color: Colors.red, fontSize: 20.0),
                              ),
                              Container(
                                width: SC.SW() / 3,
                                height: double.infinity,
                                padding: EdgeInsets.all(SC.W(10)),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: OutlineButton(
                                        onPressed: () {
                                          Provider.of<ShoppingCartProvider>(
                                                  context)
                                              .removeData(valueItem);
                                        },
                                        child: Text("-"),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: SC.W(80),
                                      child: Text(
                                        "${valueItem.count}",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: OutlineButton(
                                        onPressed: () {
                                          Provider.of<ShoppingCartProvider>(
                                                  context)
                                              .addData(valueItem);
                                        },
                                        child: Text("+"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
