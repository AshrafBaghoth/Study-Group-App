import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  ThemeCubit() : super(ThemeMode.system) {
    _loadTheme(); 
  }

  void toggleTheme() async {
    if (state == ThemeMode.light) {
      emit(ThemeMode.dark);
      _saveTheme('dark');
    } else {
      emit(ThemeMode.light);
      _saveTheme('light');
    }
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    if (themeString == 'dark') {
      emit(ThemeMode.dark);
    } else if (themeString == 'light') {
      emit(ThemeMode.light);
    } else {
      emit(ThemeMode.system);
    }
  }

  Future<void> _saveTheme(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode);
  }
}
