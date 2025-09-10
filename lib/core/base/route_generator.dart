import 'package:flutter/material.dart';
import '../../scr/home/presentation/screens/home_screen.dart';

class RouteGenerator {
  Map<String, dynamic> routs;
  RouteGenerator({required this.routs});
  static Route<dynamic> generatedRoute(RouteSettings settings) {
    switch (settings.name) {
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
