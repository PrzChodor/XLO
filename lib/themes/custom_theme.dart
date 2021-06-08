import 'package:flutter/cupertino.dart';

class CustomTheme {
  static Brightness currentBrightness = Brightness.light;
  static Function changeBrightness;
  static bool autoBrightness = true;
  static CupertinoThemeData get customTheme {
    return CupertinoThemeData(
      primaryColor: const CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.activeBlue,
          darkColor: CupertinoColors.activeOrange),
      primaryContrastingColor: const CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.white, darkColor: CupertinoColors.black),
      scaffoldBackgroundColor: const CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.extraLightBackgroundGray,
          darkColor: CupertinoColors.darkBackgroundGray),
      barBackgroundColor: const CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.white, darkColor: CupertinoColors.black),
    );
  }
}
