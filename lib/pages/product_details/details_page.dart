import 'package:b2c_shop/models/product_details.dart';
import 'package:b2c_shop/utils/ScreenAdapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class DetailPage extends StatelessWidget {
  final ProductDetailsItem arguments;
  DetailPage(this.arguments);
  @override
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(SC.W(25)),
        child: InAppWebView(
          initialData: InAppWebViewInitialData(arguments.content),
        ),
      );
}
