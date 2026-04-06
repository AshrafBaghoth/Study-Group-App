import 'package:flutter/material.dart';


final ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFF4E342E), 
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF3E2723), 
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF795548), 
    secondary: Colors.orangeAccent,
    background: Color(0xFF4E342E),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF5D4037),
    selectedItemColor: Colors.orangeAccent,
    unselectedItemColor: Colors.white70,
  ),
);


final ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFBCAAA4),
    secondary: Colors.orangeAccent,
    background: Colors.black,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.brown,
    unselectedItemColor: Colors.white54,
  ),
);
