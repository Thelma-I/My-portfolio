import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class Responsive {
  static const double mobileBreak = 600;
  static const double tabletBreak = 1024;

  static ScreenSize of(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    if (w < mobileBreak) return ScreenSize.mobile;
    if (w < tabletBreak) return ScreenSize.tablet;
    return ScreenSize.desktop;
  }

  static bool isMobile(BuildContext ctx) => of(ctx) == ScreenSize.mobile;
  static bool isDesktop(BuildContext ctx) => of(ctx) == ScreenSize.desktop;

  static double pagePadding(BuildContext ctx) {
    switch (of(ctx)) {
      case ScreenSize.mobile:
        return 20;
      case ScreenSize.tablet:
        return 48;
      case ScreenSize.desktop:
        return 80;
    }
  }

  static double maxWidth(BuildContext ctx) {
    switch (of(ctx)) {
      case ScreenSize.mobile:
        return double.infinity; // Allow full width on mobile screens
      case ScreenSize.tablet:
        return 900;              // Cap content width on tablets
      case ScreenSize.desktop:
        return 1200;             // Cap content width at a comfortable 1200px max on desktop
    }
  }

  static int gridCols(BuildContext ctx) {
    switch (of(ctx)) {
      case ScreenSize.mobile:
        return 1;
      default:
        return 2;
    }
  }
}
