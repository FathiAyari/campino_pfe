import 'dart:ui';

import 'package:get_storage/get_storage.dart';

class Constants {
  static var user = GetStorage().read("user");

  static var screenWidth = (window.physicalSize.shortestSide / window.devicePixelRatio);
  static var screenHeight = (window.physicalSize.longestSide / window.devicePixelRatio);
}
