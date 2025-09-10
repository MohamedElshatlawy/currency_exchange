import 'package:flutter/material.dart';
import '../../../home/presentation/screens/home_screen.dart';

class SplashScreenViewModel {
  SplashScreenViewModel();

  init(BuildContext context) async {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
  }
}
