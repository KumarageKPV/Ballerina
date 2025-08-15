// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData getTheme() {
    return _isDarkMode
        ? ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      buttonTheme: const ButtonThemeData(
        buttonColor: Colors.blueAccent,
      ),
      useMaterial3: true,
    )
        : ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue[300],
      scaffoldBackgroundColor: Colors.grey[200],
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black87, fontSize: 18),
        bodyMedium: TextStyle(color: Colors.black54, fontSize: 16),
      ),
      buttonTheme:  ButtonThemeData(
        buttonColor: Colors.blue[300],
      ),
      useMaterial3: true,
    );
  }
}