import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:railway/extra%20pages/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: MaterialApp(
        title: 'Transpoo',
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}