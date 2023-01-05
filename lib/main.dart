import 'package:finstagram/Pages/Login_page.dart';
import 'package:finstagram/Pages/home_page.dart';
import 'package:finstagram/Pages/register_page.dart';
import 'package:finstagram/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FirebaseService>(
    FirebaseService(),
  );
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
