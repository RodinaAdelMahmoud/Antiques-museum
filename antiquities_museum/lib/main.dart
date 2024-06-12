import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_screens/splash_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_localization/flutter_localization.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  final local;
  const MyApp({super.key, this.local});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  /*Locale _locale = const Locale('en');

  void setLocale(String languageCode) {
    setState(() {
      _locale = Locale(languageCode);
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Antiquities Museum',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffF1F8FD)),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 16)),
            // Foreground color is not applicable for gradient here, but for text color
            backgroundColor: MaterialStateProperty.all<Color>(const Color(0XFF3D77BB)), // Button color
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white), // Text color
          ),
        ),

      ),
      home:  const SplashScreen(),
    );
  }
}

