import 'package:b2c_shop/route/route_config.dart';
import 'package:b2c_shop/utils/ShoppingCartProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.white),
        onGenerateRoute: ConfigRoute.onGenerateRoute,
        initialRoute: ConfigRoute.HOME,
        routes: ConfigRoute.mainRoute,
      ),
      providers: [
        ChangeNotifierProvider(
          create: (context) => ShoppingCartProvider(),
        )
      ],
    ));
