import 'package:flutter/material.dart';
import 'package:weminal_app/views/detail_page.dart';
import 'package:weminal_app/views/login_page.dart';
import '../views/main_page.dart';

class Routes {
  static const String mainPage = "/mainPage";
  static const String loginPage = "/";
  static const String detailPage = '/detail';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.mainPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const MainPage());
      case Routes.loginPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => const LoginPage());
      case Routes.detailPage:
        return MaterialPageRoute(
            settings: routeSettings, builder: (context) => DetailPage(index: routeSettings.arguments as int));
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
