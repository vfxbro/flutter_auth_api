import 'package:flutter/material.dart';

import 'pages/Launcher.dart';
import 'pages/LoginPage.dart';

import 'pages/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Workshop1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        "/login": (context) => LoginPage(),
        "/register": (context) => RegisterPage(),
        "/launcher": (context) => Launcher(),
      },
    );
  }
}
