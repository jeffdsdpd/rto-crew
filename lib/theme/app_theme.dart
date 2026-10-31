import 'package:flutter/material.dart';

class CrewColors {
  static const navy = Color(0xFF102E45);
  static const blue = Color(0xFF087EA4);
  static const teal = Color(0xFF007F79);
  static const mist = Color(0xFFF0F7FA);
}

ThemeData buildTheme() => ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: CrewColors.blue,
    primary: CrewColors.blue,
    secondary: CrewColors.teal,
    surface: Colors.white,
  ),
  scaffoldBackgroundColor: CrewColors.mist,
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      color: CrewColors.navy,
    ),
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: CrewColors.navy,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: CrewColors.navy,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: CrewColors.navy,
    ),
    bodyMedium: TextStyle(fontSize: 14, color: CrewColors.navy, height: 1.5),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: CrewColors.mist,
    foregroundColor: CrewColors.navy,
    centerTitle: false,
  ),
  cardTheme: CardThemeData(
    elevation: 0,
    color: Colors.white,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFCCDDE4)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFFCCDDE4)),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 17),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
    ),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: Colors.white,
    indicatorColor: Color(0xFFD4F2EF),
  ),
);
