import 'dart:ui';

import 'package:b2c_shop/pages/base_page.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MState();
}

class _MState extends BaseStateWithScaffold<MyPage> {
  @override
  Widget createWidget() => Scaffold(
          body: Container(
        child: _body(),
      ));

  @override
  String getTitle() => "my";

  Widget _body() {
    return ListView(
      children: <Widget>[_top(), _featuresList()],
    );
  }

  Widget _top() {
    double centerHeight = SC.SH() / 7;
    double sigma = 1.8;
    return Container(
      alignment: Alignment.center,
      width: SC.SW(),
      height: SC.SH() / 3.5,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/sy0.png"), fit: BoxFit.cover)),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: double.infinity,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: centerHeight,
            width: double.infinity,
            padding: EdgeInsets.only(left: SC.W(20)),
            child: Row(
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    "images/me_bg.jpg",
                    fit: BoxFit.cover,
                    width: centerHeight,
                    height: centerHeight,
                  ),
                ),
                SizedBox(
                  width: SC.W(30),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "用户名：lpruoyu",
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        "普通会员",
                        style: TextStyle(color: Colors.yellow),
                      ),
                    ],
                  ),
                  height: SC.SH() / 8,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _featuresList() {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.assignment, color: Colors.red),
          title: Text("全部订单"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment, color: Colors.green),
          title: Text("待付款"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.local_car_wash, color: Colors.orange),
          title: Text("待收货"),
        ),
        _mDivider(),
        ListTile(
          leading: Icon(Icons.favorite, color: Colors.lightGreen),
          title: Text("我的收藏"),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.people, color: Colors.black54),
          title: Text("在线客服"),
        ),
        Divider(),
      ],
    );
  }

  Widget _mDivider() => Container(
      width: double.infinity,
      height: 10,
      color: Color.fromRGBO(242, 242, 242, 0.9));
}
