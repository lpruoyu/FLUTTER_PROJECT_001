import 'dart:convert';
import 'package:b2c_shop/models/product_list.dart';
import 'package:b2c_shop/pages/base_page.dart';
import 'package:b2c_shop/pages/common_page/loading.dart';
import 'package:b2c_shop/models/banner_model.dart';
import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/style/main_style.dart';
import 'package:b2c_shop/utils/Api.dart';
import 'package:b2c_shop/utils/Network.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends BaseStateWithScaffold<HomePage> {
  List<BannerItemModel> bannerList;
  List<ProductListItemModel> guessYouLikeList;
  List<ProductListItemModel> hotProductList;

  @override
  void initState() {
    super.initState();
    requestBannerData();
    requestGuessYouLikeData();
    requestHotProductData();
  }

  Widget banner() {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: bannerList == null
          ? Loading()
          : Swiper(
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: Image.network(
                    domain + bannerList[index].pic.replaceAll("\\", "/"),
                    fit: BoxFit.cover,
                  ),
                  onTap: () {
                    // 轮播图接口数据有问题
//                    Navigator.pushNamed(context, ConfigRoute.PRODUCT_DETAILS,
//                        arguments: {"id": bannerList[index].sId});
                  },
                );
              },
              itemCount: bannerList.length,
              autoplay: true,
            ),
    );
  }

  void requestBannerData() async {
    String bannerStr = await NetworkRequest.getDataFuture(bannerURL);
    BannerModel bannerModel = BannerModel.fromJson(json.decode(bannerStr));
    setState(() {
      bannerList = bannerModel.result;
    });
  }

  void requestGuessYouLikeData() async {
    String guessYouLikeStr = await NetworkRequest.getDataFuture(guessYouLike);
    ProductListModel productListModel =
        ProductListModel.fromJson(json.decode(guessYouLikeStr));
    setState(() {
      guessYouLikeList = productListModel.result;
    });
  }

  void requestHotProductData() async {
    String guessYouLikeStr = await NetworkRequest.getDataFuture(hotProduct);
    ProductListModel productListModel =
        ProductListModel.fromJson(json.decode(guessYouLikeStr));
    setState(() {
      hotProductList = productListModel.result;
    });
  }

  Widget titleBar(String s) {
    return Container(
      margin: EdgeInsets.only(top: SC.H(8), bottom: SC.H(8)),
      padding: EdgeInsets.only(top: SC.H(5), bottom: SC.H(5), left: SC.W(10)),
      decoration: BoxDecoration(
          border: Border(left: BorderSide(width: 5.0, color: Colors.red))),
      child: Text(s),
    );
  }

  Widget guessYouLikeWidget() {
    return Container(
      padding: EdgeInsets.fromLTRB(SC.W(0), SC.H(8), SC.W(0), SC.H(8)),
      height: SC.SH() / 5.5,
      width: double.infinity,
      child: guessYouLikeList == null
          ? Center(
              child: Text("加载中..."),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: guessYouLikeList.length,
              itemBuilder: (context, index) {
                var itemData = guessYouLikeList[index];
                return InkWell(
                  child: Container(
                    width: SC.SW() / 4.5,
                    margin: EdgeInsets.fromLTRB(
                        SC.W(0), SC.H(0), SC.W(20), SC.H(0)),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(
                              domain + itemData.pic.replaceAll("\\", "/"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          child: Text("￥${itemData.price}"),
                          padding: EdgeInsets.fromLTRB(
                              SC.W(0), SC.H(6), SC.W(0), SC.H(6)),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ConfigRoute.PRODUCT_DETAILS,
                        arguments: {"id": itemData.sId});
                  },
                );
              }),
    );
  }

  Widget hotProductWidget() {
    return hotProductList == null
        ? Container(
            child: Center(
              child: Text("加载中..."),
            ),
            padding: EdgeInsets.all(SC.H(50)),
          )
        : Container(
            width: double.infinity,
            child: Wrap(
              spacing: SC.W(15),
              children: hotProductList
                  .map((v) => InkWell(
                        child: Container(
                          margin:
                              EdgeInsets.only(top: SC.H(8), bottom: SC.H(8)),
                          padding: EdgeInsets.all(SC.W(20)),
                          width: (SC.SW() - SC.W(15) - SC.W(15) * 2) / 2,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12)),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Image.network(
                                  domain + v.pic.replaceAll("\\", "/"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.fromLTRB(0, SC.H(8), 0, SC.H(8)),
                                child: Text(
                                  v.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "￥${v.price}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20.0),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "￥${v.oldPrice}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, ConfigRoute.PRODUCT_DETAILS,
                              arguments: {"id": v.sId});
                        },
                      ))
                  .toList(),
            ),
          );
  }

  @override
  Widget createWidget() => Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.center_focus_weak),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          )
        ],
        title: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ConfigRoute.SEARCH);
          },
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "笔记本",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0, color: Colors.black54),
                )
              ],
            ),
            padding: EdgeInsets.only(left: SC.W(15)),
            width: SC.SW() / 3 * 2,
            height: SC.H(68),
            decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(SC.W(30))),
          ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            banner(),
            Padding(
              padding:
                  EdgeInsets.fromLTRB(SC.W(15), SC.H(12), SC.W(12), SC.H(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  titleBar("猜你喜欢"),
                  guessYouLikeWidget(),
                  SizedBox(
                    height: SC.H(8),
                  ),
                  titleBar("热门推荐"),
                  hotProductWidget(),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: SC.H(20), bottom: SC.H(40)),
              child: Text(
                "- - - - > 没有更多了 < - - - -",
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ));

  @override
  String getTitle() => "home";
}
