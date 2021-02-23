import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/style/main_style.dart';
import 'package:b2c_shop/utils/Network.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:b2c_shop/utils/SharedPreferences.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    requestHistoryData();
  }

  @override
  void dispose() {
    NetworkRequest.dio = null;
    super.dispose();
  }

  Widget _productTag(String title) => InkWell(
        child: Container(
          margin: EdgeInsets.all(SC.W(15)),
          padding: EdgeInsets.all(SC.W(15)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromRGBO(233, 233, 233, 0.9)),
          child: Text(
            title,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: () {
          SharedPreferencesUtil.addHistoryData(KEY_HISTORY, title);
          Navigator.pushReplacementNamed(context, ConfigRoute.PRODUCT_LIST,
              arguments: {"search": title, "title": title});
        },
      );

  Widget _historyTile(title) => Column(
        children: <Widget>[
          InkWell(
            child: ListTile(
              title: Text(title),
            ),
            onLongPress: () {
              _showAlertDialog(title);
            },
            onTap: () {
              setState(() {
                textEditingController.text = title;
              });
            },
          ),
          Divider(),
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: <Widget>[
            Container(
              alignment: Alignment.center,
              child: AspectRatio(
                aspectRatio: 1,
                child: InkWell(
                  onTap: () async {
                    var str = textEditingController.text;
                    if (isEmpty(str)) return;
                    SharedPreferencesUtil.addHistoryData(KEY_HISTORY, str);
                    Navigator.pushReplacementNamed(
                        context, ConfigRoute.PRODUCT_LIST,
                        arguments: {"search": str});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "搜索",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              margin: EdgeInsets.only(
                  top: SC.H(20), bottom: SC.H(20), right: SC.W(20)),
              height: double.infinity,
            )
          ],
          title: Container(
            alignment: Alignment.center,
            child: TextField(
              controller: textEditingController,
              autofocus: true,
              maxLines: 1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  hintText: "做最好的自己",
                  contentPadding: EdgeInsets.only(top: SC.H(3))),
            ),
            padding: EdgeInsets.only(left: SC.W(15), right: SC.W(15)),
            width: SC.SW() / 3 * 2,
            height: SC.H(68),
            decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.circular(SC.W(30))),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(SC.W(20)),
          child: ListView(
            children: <Widget>[
              Text(
                "热搜",
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 10,
              ),
              Wrap(
                children: <Widget>[
                  _productTag("笔记本"),
                  _productTag("笔记本电脑"),
                  _productTag("手机"),
                  _productTag("小米"),
                  _productTag("平板电脑"),
                  _productTag("生活用品"),
                  _productTag("学习用品"),
                  _productTag("书籍"),
                  _productTag("iPhone手机"),
                  _productTag("Android手机"),
                  _productTag("华为"),
                  _productTag("床上用品"),
                  _productTag("办公用品"),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "历史搜索",
                style: Theme.of(context).textTheme.title,
              ),
              Divider(),
              historyList(),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      );

  List history;

  Widget historyList() => Column(
        children: <Widget>[
          history == null || history.length == 0
              ? Container(
                  padding: EdgeInsets.only(top: SC.H(20), bottom: SC.H(20)),
                  child: Center(
                    child: Text("暂时还没有搜索记录"),
                  ),
                )
              : Column(children: history.map((v) => _historyTile(v)).toList()),
          SizedBox(
            height: 20,
          ),
          history == null || history.length == 0 ? Text("") : clearHistory(),
        ],
      );

  Widget clearHistory() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              width: SC.SW() / 3 * 2,
              height: SC.SH() / 15,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.delete),
                  Text("清空历史记录"),
                ],
              ),
            ),
            onTap: () async {
              bool isd =
                  await SharedPreferencesUtil.clearHistoryData(KEY_HISTORY);
              if (isd) requestHistoryData();
            },
          ),
        ],
      );

  void requestHistoryData() async {
    List historyDataList =
        await SharedPreferencesUtil.getHistoryDataList(KEY_HISTORY);
    setState(() {
      this.history = historyDataList;
    });
  }

  void _showAlertDialog(String keywords) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示！"),
            content: Text("您确定要删除$keywords吗?"),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  "取消",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  "确定",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await SharedPreferencesUtil.removeHistoryData(
                      KEY_HISTORY, keywords);
                  requestHistoryData();
                },
              ),
            ],
          );
        });
  }
}
