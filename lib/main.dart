import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weminal_app/views/main_page.dart';
import 'package:weminal_app/viewmodels/topic_provider.dart';
import 'package:weminal_app/utilities/router_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TopicProvider()),
      ],
      child: const MaterialApp(
        initialRoute: Routes.loginPage,
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
