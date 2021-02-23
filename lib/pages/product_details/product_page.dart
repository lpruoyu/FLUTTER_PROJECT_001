import 'package:b2c_shop/models/product_details.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/style/main_style.dart';
import 'package:b2c_shop/utils/Api.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:b2c_shop/utils/ShoppingCartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class ProductPage extends StatelessWidget {
  final ProductDetailsItem _productDetailsItem;

  ProductPage(this._productDetailsItem);

  void showToast(context, String msg) {
    Toast.show(msg, context,
        backgroundColor: greyColor, textColor: Colors.black);
  }

  @override
  Widget build(BuildContext context) {
    var _bottomHeight = SC.SH() / 12;
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            width: SC.SW(),
            height: _bottomHeight,
            child: Container(
              decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12))),
              padding: EdgeInsets.only(top: SC.H(10), bottom: SC.H(10)),
              child: Row(
                children: <Widget>[
                  InkWell(
                    child: Container(
                      width: SC.SW() / 3,
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.shopping_cart),
                          Text("购物车")
                        ],
                      ),
                    ),
                    onTap: () {

                    },
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: SC.W(15)),
                              alignment: Alignment.center,
                              child: Text(
                                "加入购物车",
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(253, 1, 0, 0.9),
                                borderRadius: BorderRadius.circular(SC.W(15)),
                              ),
                            ),
                            onTap: () async {
                              await Provider.of<ShoppingCartProvider>(context)
                                  .addData(_productDetailsItem);
                              showToast(context, "加入购物车成功");
                            },
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              margin: EdgeInsets.only(right: SC.W(15)),
                              alignment: Alignment.center,
                              child: Text(
                                "立即购买",
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(255, 165, 0, 0.9),
                                borderRadius: BorderRadius.circular(SC.W(15)),
                              ),
                            ),
                            onTap: () {},
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _productDetailsItem == null
              ? Loading()
              : Container(
                  padding: EdgeInsets.only(left: SC.W(20), right: SC.W(20)),
                  child: ListView(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 16 / 13,
                        child: Image.network(
                          "${domain + _productDetailsItem.pic.replaceAll("\\", "/")}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(_productDetailsItem.title,
                            style:
                                TextStyle(color: Colors.black87, fontSize: 18)),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                              _productDetailsItem.subTitle == null
                                  ? ""
                                  : _productDetailsItem.subTitle,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 14))),
                      SizedBox(
                        height: SC.H(25),
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "特价：",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                  ),
                                ),
                                Text("￥${_productDetailsItem.price}",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 28,
                                    )),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "原价：",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  "￥${_productDetailsItem.oldPrice}",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ],
                            ),
                          ],
                        ),
                        margin: EdgeInsets.only(bottom: SC.H(25)),
                      ),
                      Divider(),
                      _productDetailsItem.attr == null ||
                              _productDetailsItem.attr.length < 0
                          ? Text("")
                          : Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                  top: SC.H(20), bottom: SC.H(20)),
                              margin: EdgeInsets.only(bottom: SC.H(25)),
                              child: Column(
                                children: _productDetailsItem.attr
                                    .map<Widget>((value) => _infoItem(value))
                                    .toList(),
                              ),
                            ),
                      SizedBox(
                        height: SC.H(50),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(bottom: _bottomHeight),
                )
        ],
      ),
    );
  }

  Widget _infoItem(value) => Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                child: Text(
                  "${value.cate}",
                  style: TextStyle(color: Colors.black, fontSize: 19),
                ),
                margin: EdgeInsets.only(right: SC.W(20)),
              ),
              Row(
                children: value.list.map<Widget>((v) => productTag(v)).toList(),
              ),
            ],
          ),
          Divider(),
        ],
      );

  Widget productTag(String info) => Container(
        child: Text(
          info,
          style: TextStyle(color: Colors.black54, fontSize: 16.0),
        ),
        margin: EdgeInsets.only(right: SC.W(15)),
      );
}
