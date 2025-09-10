import 'package:flutter/material.dart';
import '../../scr/home/presentation/screens/home_screen.dart';
import '../../scr/splash/presentation/screens/splash_screen.dart';

class RouteGenerator {
  Map<String, dynamic> routs;
  RouteGenerator({required this.routs});
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
      case SplashScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
          settings: RouteSettings(name: SplashScreen.routeName),
        );
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
          settings: RouteSettings(name: HomeScreen.routeName),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('ERROR')),
        );
      },
    );
  }
}
