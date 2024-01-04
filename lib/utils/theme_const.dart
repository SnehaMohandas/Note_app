import 'package:flutter/material.dart';
import 'package:notes_app/utils/color_constant.dart';

final darkTheme = ThemeData(
    fontFamily: "Sk-Modernist",
    primarySwatch: Colors.grey,
    primaryColor: const Color.fromARGB(255, 92, 136, 130),
    brightness: Brightness.dark,
    backgroundColor: const Color(0xFF212121),
    hintColor: Colors.white,

    // actionIconTheme: IconThemeData(color: Colors.black),
    dividerColor: Colors.black12,
    cardColor: const Color.fromARGB(255, 95, 98, 109));

final lightTheme = ThemeData(
    fontFamily: "Sk-Modernist",
    primarySwatch: Colors.deepPurple,
    primaryColor: const Color.fromARGB(255, 22, 85, 85),
    brightness: Brightness.light,
    backgroundColor: const Color(0xFFE5E5E5),
    hintColor: Colors.black,
    //actionIconTheme: IconThemeData(color: Colors.white),
    dividerColor: Colors.white54,
    cardColor: ColorConstant.cardColor);
