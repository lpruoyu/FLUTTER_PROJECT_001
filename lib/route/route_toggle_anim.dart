import 'package:flutter/material.dart';

class RoutePageBuilderAnim extends PageRouteBuilder {
  final Widget page;

  RoutePageBuilderAnim(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(animation),
              child: child,
            ),
            position:
                Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                    .animate(animation),
          ),
        );
}
