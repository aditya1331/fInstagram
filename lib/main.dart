import 'package:finstagram/Pages/Login_page.dart';
import 'package:finstagram/Pages/home_page.dart';
import 'package:finstagram/Pages/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FInstagram',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      initialRoute: 'home',
      routes: {
        'register':(context) => RegisterPage(),
        'login': (context) => LoginPage(),
        'home': (context) => HomePage(),
      },
    );
  }
}
