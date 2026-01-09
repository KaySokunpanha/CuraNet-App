import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';


String _appTheme = "primary";
ThemeData get theme => ThemeHelper().themeData();


/// Helper class for managing themes and colors.
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, PrimaryColors> _supportedCustomColor = {
    'primary': PrimaryColors()
  };


  // A map of color schemes supported by the app
  final Map<String, ColorScheme> _supportedColorScheme = {
    'primary': ColorSchemes.primaryColorScheme
  };


  /// Changes the app theme to [_newTheme].
  void changeTheme(String newTheme) {
    _appTheme = newTheme;
  }


  /// Returns the primary colors for the current theme.
  PrimaryColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? PrimaryColors();
  }


  /// Returns the current theme data.
  ThemeData _getThemeData() {
    var colorScheme =
        _supportedColorScheme[_appTheme] ?? ColorSchemes.primaryColorScheme;
    return ThemeData(
      visualDensity: VisualDensity.standard,
      colorScheme: colorScheme,
      textTheme: TextThemes.textTheme(colorScheme),
      scaffoldBackgroundColor: colorScheme.surface,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: colorScheme.primary,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: const VisualDensity(
            vertical: -4,
            horizontal: -4,
          ),
          padding: EdgeInsets.zero,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        space: 1,
        color: colorScheme.outline,
      ),
    );
  }


  /// Returns the primary colors for the current theme.
  PrimaryColors themeColor() => _getThemeColors();


  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}


/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: colorScheme.onSurfaceVariant,
          fontSize: 12.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 32.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 28.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 24.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        labelMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 12.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 10.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleLarge: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 22.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 16.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 14.sp,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      );
}


/// Class containing the supported color schemes.
class ColorSchemes {
  static const primaryColorScheme = ColorScheme.light(
    primary: Color(0xFF0066CC),
    primaryContainer: Color(0xFFD1E4FF),
    secondary: Color(0xFF00A896),
    secondaryContainer: Color(0xFFCCE8E4),
    tertiary: Color(0xFF7D5260),
    tertiaryContainer: Color(0xFFFFD8E4),
    surface: Color(0xFFF8F9FA),
    onSurface: Color(0xFF1A1C1E),
    onSurfaceVariant: Color(0xFF42474E),
    outline: Color(0xFF72777F),
    onInverseSurface: Color(0xFFF0F1F3),
    inverseSurface: Color(0xFF2E3135),
    inversePrimary: Color(0xFF9ECAFF),
    shadow: Color(0xFF000000),
    error: Color(0xFFBA1A1A),
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF001D36),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFF00201C),
    onTertiary: Color(0xFFFFFFFF),
    onTertiaryContainer: Color(0xFF31111D),
  );
}


/// Class containing custom colors for a primary theme.
class PrimaryColors {
  // Brand colors
  Color get brandPrimary => const Color(0xFF0066CC);
  Color get brandSecondary => const Color(0xFF00A896);
  Color get brandAccent => const Color(0xFFFF6B6B);


  // Text colors
  Color get textPrimary => const Color(0xFF1A1C1E);
  Color get textSecondary => const Color(0xFF42474E);
  Color get textHint => const Color(0xFF72777F);


  // Background colors
  Color get backgroundPrimary => const Color(0xFFF8F9FA);
  Color get backgroundSecondary => const Color(0xFFFFFFFF);


  // Status colors
  Color get success => const Color(0xFF10B981);
  Color get warning => const Color(0xFFF59E0B);
  Color get error => const Color(0xFFEF4444);
  Color get info => const Color(0xFF3B82F6);
}
