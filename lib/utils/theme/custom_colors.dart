import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.primaryColor,
    required this.themeBorder,
    required this.themeBackground,
    required this.themeSurface,
    required this.themeTextPrimary,
    required this.themeTextSecondary,
    required this.themeTextFieldBackgroud,
    required this.themeTextFieldHintText,
    required this.themeTextFieldIcon,
    required this.themeTextFieldValue,
    required this.themeCheckboxBackground,
  });

  final Color primaryColor;
  final Color themeBorder;
  final Color themeBackground;
  final Color themeSurface;
  final Color themeTextPrimary;
  final Color themeTextSecondary;
  final Color themeTextFieldBackgroud;
  final Color themeTextFieldHintText;
  final Color themeTextFieldIcon;
  final Color themeTextFieldValue;
  final Color themeCheckboxBackground;

  @override
  CustomColors copyWith({
    Color? primaryColor,
    Color? themeBorder,
    Color? themeBackground,
    Color? themeSurface,
    Color? themeTextPrimary,
    Color? themeTextSecondary,
    Color? themeTextFieldBackgroud,
    Color? themeTextFieldHintText,
    Color? themeTextFieldIcon,
    Color? themeTextFieldValue,
    Color? themeCheckboxBackground,
  }) {
    return CustomColors(
      primaryColor: primaryColor ?? this.primaryColor,
      themeBorder: themeBorder ?? this.themeBorder,
      themeBackground: themeBackground ?? this.themeBackground,
      themeSurface: themeSurface ?? this.themeSurface,
      themeTextPrimary: themeTextPrimary ?? this.themeTextPrimary,
      themeTextSecondary: themeTextSecondary ?? this.themeTextSecondary,
      themeTextFieldBackgroud:
          themeTextFieldBackgroud ?? this.themeTextFieldBackgroud,
      themeTextFieldHintText:
          themeTextFieldHintText ?? this.themeTextFieldHintText,
      themeTextFieldIcon: themeTextFieldIcon ?? this.themeTextFieldIcon,
      themeTextFieldValue: themeTextFieldValue ?? this.themeTextFieldValue,
      themeCheckboxBackground:
          themeCheckboxBackground ?? this.themeCheckboxBackground,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      primaryColor: Color.lerp(primaryColor, other.primaryColor, t)!,
      themeBorder: Color.lerp(themeBorder, other.themeBorder, t)!,
      themeBackground: Color.lerp(themeBackground, other.themeBackground, t)!,
      themeSurface: Color.lerp(themeSurface, other.themeSurface, t)!,
      themeTextPrimary:
          Color.lerp(themeTextPrimary, other.themeTextPrimary, t)!,
      themeTextSecondary:
          Color.lerp(themeTextSecondary, other.themeTextSecondary, t)!,
      themeTextFieldBackgroud:
          Color.lerp(
            themeTextFieldBackgroud,
            other.themeTextFieldBackgroud,
            t,
          )!,
      themeTextFieldHintText:
          Color.lerp(themeTextFieldHintText, other.themeTextFieldHintText, t)!,
      themeTextFieldIcon:
          Color.lerp(themeTextFieldIcon, other.themeTextFieldIcon, t)!,
      themeTextFieldValue:
          Color.lerp(themeTextFieldValue, other.themeTextFieldValue, t)!,
      themeCheckboxBackground:
          Color.lerp(
            themeCheckboxBackground,
            other.themeCheckboxBackground,
            t,
          )!,
    );
  }
}
