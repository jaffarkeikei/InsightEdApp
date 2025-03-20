import 'package:flutter/material.dart';

class ColorConstants {
  // Primary & Accent Colors
  static final Color primaryColor = Color(
    0xFF1A5D1A,
  ); // Green color for education
  static final Color accentColor = Color(0xFF2E8B57); // Sea Green

  // Light Theme Colors
  static final Color backgroundColor = Color(0xFFF5F5F5);
  static final Color surfaceColor = Colors.white;
  static final Color inputFillColor = Color(0xFFF0F0F0);

  // Dark Theme Colors
  static final Color darkBackgroundColor = Color(0xFF121212);
  static final Color darkSurfaceColor = Color(0xFF1E1E1E);
  static final Color darkInputFillColor = Color(0xFF2C2C2C);

  // Status Colors
  static final Color errorColor = Color(0xFFE53935);
  static final Color successColor = Color(0xFF43A047);
  static final Color warningColor = Color(0xFFFFA000);
  static final Color infoColor = Color(0xFF1E88E5);

  // Text Colors
  static final Color primaryTextColor = Color(0xFF212121);
  static final Color secondaryTextColor = Color(0xFF757575);
  static final Color darkPrimaryTextColor = Colors.white;
  static final Color darkSecondaryTextColor = Color(0xFFB0B0B0);

  // Chart Colors
  static final List<Color> chartColors = [
    Color(0xFF1A5D1A), // Primary Green
    Color(0xFF43A047), // Success Green
    Color(0xFF2E8B57), // Sea Green
    Color(0xFF1E88E5), // Info Blue
    Color(0xFFFFA000), // Warning Amber
    Color(0xFFE53935), // Error Red
    Color(0xFF8E24AA), // Purple
    Color(0xFF6D4C41), // Brown
  ];
}
