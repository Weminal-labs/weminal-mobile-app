import 'package:flutter/material.dart';
import 'package:weminal_app/views/detail_page.dart';
import 'package:weminal_app/views/detail_ticket_page.dart';
import 'package:weminal_app/views/login_page.dart';
import '../views/main_page.dart';

class Routes {
  static const String mainPage = "/mainPage";
  static const String loginPage = "/";
  static const String detailPage = '/detail';
  static const String detailTicketPage = 'detailTicketPage';
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
            settings: routeSettings,
            builder: (context) =>
                DetailPage(index: routeSettings.arguments as int));
      case Routes.detailTicketPage:
        List<dynamic> args = routeSettings.arguments as List<dynamic>;

        return MaterialPageRoute(
            settings: routeSettings,
            builder: (context) => DetailTicketPage(
                  index: args[0] as int,
                  nftInfo: args[1],
                ));
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
