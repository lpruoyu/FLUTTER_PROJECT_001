import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/*
  屏幕适配
 */

class SC {

  // 在使用之前必须被初始化
  static void init(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }

  static double W(double width) => ScreenUtil.getInstance().setWidth(width);

  static double H(double height) => ScreenUtil.getInstance().setHeight(height);

  static double SW() => ScreenUtil.screenWidthDp;

  static double SH() => ScreenUtil.screenHeightDp;

}
