import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: const Color(0xFF3A9E9E),
    scaffoldBackgroundColor: const Color(0xFFFDFDFD),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF3A9E9E),
      secondary: Color(0xFF72CFCF),
      surface: Colors.white,
      onSurface: Color(0xFF2D3142),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF2D3142)),
      bodyMedium: TextStyle(color: Color(0xFF2D3142)),
      headlineSmall: TextStyle(color: Color(0xFF2D3142), fontWeight: FontWeight.bold),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF72CFCF),
    scaffoldBackgroundColor: const Color(0xFF0F0F12),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF72CFCF),
      secondary: Color(0xFF3A9E9E),
      surface: Color(0xFF1C1C1E),
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF0F0F12),
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.2,
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1C1C1E),
    ),
  );
}
