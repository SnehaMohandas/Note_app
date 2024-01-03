import 'package:flutter/material.dart';
import 'package:notes_app/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class ThemeNotifier with ChangeNotifier {
//   ThemeData _themeData;

//   ThemeNotifier(this._themeData);

//   getTheme() => _themeData;

//   setTheme(ThemeData themeData) async {
//     _themeData = themeData;
//     notifyListeners();
//   }

//   void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
//     (value)
//         ? themeNotifier.setTheme(darkTheme)
//         : themeNotifier.setTheme(lightTheme);
//     var prefs = await SharedPreferences.getInstance();
//     prefs.setBool('darkMode', value);
//   }
// }
class ThemeNotifier with ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeNotifier(this._isDarkMode, this._themeData) {
    _themeData = _isDarkMode ? darkTheme : lightTheme;
  }

  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    notifyListeners();
  }

  bool get isDarkMode => _isDarkMode;

  void onThemeChanged(bool value, ThemeNotifier themeNotifier) async {
    print("ison====>${value}");
    _isDarkMode = value;
    (value)
        ? themeNotifier.setTheme(darkTheme)
        : themeNotifier.setTheme(lightTheme);
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', value);
  }
}
