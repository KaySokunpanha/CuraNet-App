import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'theme_helper.dart';


class AppDecoration {
  // Fill decorations
  static BoxDecoration get fillPrimary => BoxDecoration(
        color: theme.colorScheme.primary,
      );
  static BoxDecoration get fillSurface => BoxDecoration(
        color: theme.colorScheme.surface,
      );
  static BoxDecoration get fillBackground => BoxDecoration(
        color: theme.colorScheme.surface,
      );


  // Outline decorations
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1,
        ),
      );
  static BoxDecoration get outlineError => BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border.all(
          color: theme.colorScheme.error,
          width: 1,
        ),
      );


  // Gradient decorations
  static BoxDecoration get gradientPrimaryToSecondary => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.secondary,
          ],
        ),
      );
}


class BorderRadiusStyle {
  // Circle borders
  static BorderRadius get circleBorder => BorderRadius.circular(50.w);


  // Rounded borders
  static BorderRadius get roundedBorder8 => BorderRadius.circular(8);
  static BorderRadius get roundedBorder12 => BorderRadius.circular(12);
  static BorderRadius get roundedBorder16 => BorderRadius.circular(16);
  static BorderRadius get roundedBorder24 => BorderRadius.circular(24);


  // Custom borders
  static BorderRadius get customBorderTL12 => const BorderRadius.only(
        topLeft: Radius.circular(12),
      );
}
