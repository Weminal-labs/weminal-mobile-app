import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weminal_app/utilities/router_manager.dart';
import 'package:weminal_app/viewmodels/topic_provider.dart';
import 'package:weminal_app/views/home_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TopicProvider()),
      ],
      child: const MaterialApp(
        initialRoute: Routes.mainPage,
        onGenerateRoute: RouteGenerator.getRoute,
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      ),
    ),
  );
}
