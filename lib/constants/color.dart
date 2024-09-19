import 'package:flutter/material.dart';

class MQColor {

  // Primary and secondary colors
  static const Color primaryColor = Color(0xffb71c1c); // Dark Red for primary actions
  static const Color secondaryColor = Color(0xfff44336); // Lighter red for secondary actions or highlights

  // Background colors
  static const Color bgColorDarker = Color(0xff2B2B2B); // Darker background with a slight red tint
  static const Color bgColorDark = Color.fromARGB(255, 80, 44, 44); // Dark gray with enough contrast for readability
  static const Color bgColorLight = Color.fromARGB(255, 99, 72, 72); // Slightly lighter background, still dark

  // Text colors
  static const Color textColor = Color(0xfff5f5f5); // Light gray for readability on dark backgrounds
  static const Color textColorInverse = Color(0xffb71c1c); // Dark red for inverse elements (used on lighter backgrounds)
  static const Color textColorDisabled = Color(0xff9e9e9e); // Neutral gray for disabled text
  static const Color transparent = Colors.transparent;

  // Action button text color
  static const Color actionButtonTextColor = bgColorDark;
  static const Color inputFormFieldBackground = bgColorLight;

  // Accent colors for success, warning, etc.
  static final Color accentOrange = Color(0xffffb74d); // Slightly darker orange for highlights
  static final Color accentYellow = Color(0xfffff176); // For warning or neutral highlights
  static final Color accentGreen = Color(0xff66bb6a); // Green for success (e.g., correct answers)
  static const Color accentRedAccent = Color(0xffd32f2f); // A less intense red for accent highlights
  static final Color accentPink = Color(0xffe57373); // Soft pink for subtle accents

  // Error colors
  static const Color formErrorHint = Color(0xffff7043); // Strong orange for error hints
  static const Color error = formErrorHint;

  static const Color fatalError = Color(0xffef5350); // shade 100
  // static const Color fatalError = Color(0xffd32f2f); // shade 100

  static const Color systemNavBar = MQColor.bgColorDark;
  static const Brightness systemNavBarBrightness = Brightness.light;

  // static const Color systemNavBar = MQColor.bgColorDark;
  // static const Brightness systemNavBarBrightness = Brightness.light;
  //
  // static const Color bottomNavBar = Colors.white;
  // static const Brightness bottomNavBarBrightness = Brightness.dark;

}