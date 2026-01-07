import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  static const String themeStatusKey = "THEME_STATUS";

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadTheme();
  }

  /// Load stored theme on startup
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkTheme = prefs.getBool(themeStatusKey) ?? false;
    notifyListeners();
  }

  /// Toggle theme + save to SharedPreferences
  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(themeStatusKey, _isDarkTheme);

    notifyListeners();
  }
}
