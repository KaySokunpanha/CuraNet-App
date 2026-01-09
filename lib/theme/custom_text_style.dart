import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
import 'theme_helper.dart';


extension on TextStyle {
  // TextStyle get roboto {
  //   return copyWith(
  //     fontFamily: 'Roboto',
  //   );
  // }
}


/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
  // Body text style
  static TextStyle get bodyLargePrimary => theme.textTheme.bodyLarge!.copyWith(
        color: theme.colorScheme.primary,
      );
  static TextStyle get bodyMediumOnSurface => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onSurface,
      );
  static TextStyle get bodyMediumOnSurfaceVariant => theme.textTheme.bodyMedium!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      );
  static TextStyle get bodySmallOnSurfaceVariant => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      );


  // Headline text style
  static TextStyle get headlineLargePrimary =>
      theme.textTheme.headlineLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static TextStyle get headlineMediumOnSurface =>
      theme.textTheme.headlineMedium!.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      );


  // Label text style
  static TextStyle get labelLargePrimary =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get labelMediumOnPrimary =>
      theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.onPrimary,
      );


  // Title text style
  static TextStyle get titleLargeOnSurface =>
      theme.textTheme.titleLarge!.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleMediumPrimary =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
      );
  static TextStyle get titleSmallOnSurfaceVariant =>
      theme.textTheme.titleSmall!.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      );
}
