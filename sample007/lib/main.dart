import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sample007/home.dart';
import 'package:sample007/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:sample007/signup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
