import 'dart:convert';

import 'package:b2c_shop/models/product_catrgory.dart';
import 'package:b2c_shop/pages/base_page.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/style/main_style.dart';
import 'package:b2c_shop/utils/Api.dart';
import 'package:b2c_shop/utils/Network.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends BaseStateWithScaffold<CategoryPage> {
  List<ProductCategoryItemModel> productCate1List;
  List<ProductCategoryItemModel> productCate2List;

  @override
  Widget createWidget() => Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("商品分类"),
        ),
        body: Container(
          child: Row(
            children: <Widget>[
              leftWidget(),
              Expanded(
                child: rightWidget(),
                flex: 1,
              )
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    requestCate1Data();
  }

  void requestCate2Data(id) async {
    String productCate2Str =
        await NetworkRequest.getDataFuture(productCate2 + id);
    ProductCategoryModel productCategoryModel =
        ProductCategoryModel.fromJson(json.decode(productCate2Str));
    setState(() {
      productCate2List = productCategoryModel.result;
    });
  }

  void requestCate1Data() async {
    String productCate1Str = await NetworkRequest.getDataFuture(productCate1);
    ProductCategoryModel productCategoryModel =
        ProductCategoryModel.fromJson(json.decode(productCate1Str));
    setState(() {
      productCate1List = productCategoryModel.result;
    });
    requestCate2Data(productCate1List[_selectedIndex].sId);
  }

  int _selectedIndex = 0;

  Widget leftWidget() {
    return Container(
        width: SC.SW() / 4,
        height: double.infinity,
        color: Colors.white,
        child: productCate1List == null
            ? Center(
                child: Text("加载中..."),
              )
            : ListView.builder(
                itemBuilder: (context, index) {
                  return Container(
                    color: _selectedIndex == index
                        ? categoryBgColor
                        : Colors.white,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        requestCate2Data(productCate1List[_selectedIndex].sId);
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.center,
                            height: SC.SH() / 12,
                            width: double.infinity,
                            child: Text(
                              "${productCate1List[index].title}",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Divider(
                            height: 1,
                          )
                        ],
                      ),
                    ),
                  );
                },
                itemCount: productCate1List.length,
              ));
  }

  Widget rightWidget() => Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(SC.W(25)),
      color: categoryBgColor,
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(SC.W(35), SC.H(25), SC.W(35), SC.H(25)),
        child: productCate2List == null
            ? Loading()
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: SC.H(18),
                    mainAxisSpacing: SC.W(18),
                    childAspectRatio: 3 / 4),
                itemCount: productCate2List.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ConfigRoute.PRODUCT_LIST,
                          arguments: {
                            "cid": productCate2List[index].sId,
                            "title": productCate2List[index].title
                          });
                    },
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Image.network(
                              domain +
                                  productCate2List[index]
                                      .pic
                                      .replaceAll("\\", "/"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            child: Text(
                              productCate2List[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            padding: EdgeInsets.all(SC.W(5)),
                          )
                        ],
                      ),
                    ),
                  );
                }),
      ));

  @override
  String getTitle() => "category";
}
