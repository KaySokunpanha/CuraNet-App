import 'dart:ui';
import 'package:flutter/material.dart';

class SizeUtils {
  static double get width => MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.width;
  static double get height => MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size.height;
}
