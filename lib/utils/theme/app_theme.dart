import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _lightCustomColors = CustomColors(
    primaryColor: ColorConstants.primaryColor,
    themeBorder: ColorConstants.lightThemeBorder,
    themeBackground: ColorConstants.lightThemeBackground,
    themeSurface: ColorConstants.lightThemeSurface,
    themeTextPrimary: ColorConstants.lightThemeTextPrimary,
    themeTextSecondary: ColorConstants.lightThemeTextSecondary,
    themeTextFieldBackgroud: ColorConstants.lightThemeTextFieldBackground,
    themeTextFieldHintText: ColorConstants.lightThemeTextFieldHintText,
    themeTextFieldIcon: ColorConstants.lightThemeTextFieldIcon,
    themeTextFieldValue: ColorConstants.lightThemeTextFieldValue,
    themeCheckboxBackground: ColorConstants.lightThemeCheckboxBackground,
  );

  static const _darkCustomColors = CustomColors(
    primaryColor: ColorConstants.primaryColor,
    themeBorder: ColorConstants.darkThemeBorder,
    themeBackground: ColorConstants.darkThemeBackground,
    themeSurface: ColorConstants.darkThemeSurface,
    themeTextPrimary: ColorConstants.darkThemeTextPrimary,
    themeTextSecondary: ColorConstants.darkThemeTextSecondary,
    themeTextFieldBackgroud: ColorConstants.darkThemeTextFieldBackground,
    themeTextFieldHintText: ColorConstants.darkThemeTextFieldHintText,
    themeTextFieldIcon: ColorConstants.darkThemeTextFieldIcon,
    themeTextFieldValue: ColorConstants.darkThemeTextFieldValue,
    themeCheckboxBackground: ColorConstants.darkThemeCheckboxBackground,
  );

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorConstants.lightThemeTextPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorConstants.lightThemeTextSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ColorConstants.lightThemeTextSecondary,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[_lightCustomColors],
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: ColorConstants.darkThemeTextPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ColorConstants.darkThemeTextSecondary,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ColorConstants.darkThemeTextSecondary,
      ),
    ),
    extensions: <ThemeExtension<dynamic>>[_darkCustomColors],
  );
}
