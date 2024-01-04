import 'package:flutter/material.dart';
import 'package:notes_app/utils/color_constant.dart';
import 'package:notes_app/views/home_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          ColorConstant.cardColor, // Set your desired background color
      body: Center(
        child: FadeInSplashContent(), // Use your animated splash content widget
      ),
    );
  }
}

class FadeInSplashContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        onEnd: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        },
        builder: (context, double value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(seconds: 2),
            onEnd: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }));
            },
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child:
                //   child:
                Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/logo.png', // Replace with your image asset path
                  width: MediaQuery.of(context).size.height * 0.4,
                  height: MediaQuery.of(context).size.width * 0.4,
                ),
              ],
            )));
  }
}
