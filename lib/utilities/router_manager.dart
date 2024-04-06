import 'package:flutter/material.dart';
import 'package:weminal_app/views/login_page.dart';
import 'package:weminal_app/zkLogin/zklogin_page.dart';

import '../views/main_page.dart';

class Routes {
  static const String mainPage = "/";
  static const String loginPage = "/login";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(builder: (context) => const MainPage());
      case Routes.loginPage:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('No route found'),
              ),
              body: const Center(child: Text('No route found')),
            ));
  }
}
