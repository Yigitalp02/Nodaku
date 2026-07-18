import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFFFF6584);
  static const Color background = Color(0xFFF5F4FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color circleEmpty = Color(0xFFEDE9FF);
  static const Color circleFilled = Color(0xFF6C63FF);
  static const Color circleWrong = Color(0xFFFF6584);
  static const Color circleCorrect = Color(0xFF43C59E);
  static const Color lineColor = Color(0xFF9E9BB5);
  static const Color productColor = Color(0xFF3D3A5C);
  static const Color textPrimary = Color(0xFF3D3A5C);
  static const Color textSecondary = Color(0xFF9E9BB5);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: background,
          surface: surface,
        ),
        scaffoldBackgroundColor: background,
        textTheme: GoogleFonts.poppinsTextTheme().copyWith(
          displayLarge: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textPrimary,
          ),
          headlineMedium: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: textPrimary,
          ),
          titleMedium: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimary,
          ),
          bodyMedium: GoogleFonts.poppins(
            fontSize: 14,
            color: textSecondary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
}
