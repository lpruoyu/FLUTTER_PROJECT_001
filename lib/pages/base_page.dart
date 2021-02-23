import 'package:flutter/material.dart';

abstract class BaseStateWithScaffold<T> extends State with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) => createWidget();

  @override
  bool get wantKeepAlive => true;

  Widget createWidget();

  String getTitle();
}
