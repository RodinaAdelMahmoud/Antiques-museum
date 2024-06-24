import 'dart:async';

import 'package:antiquities_museum/app_screens/home_screen.dart';
import 'package:antiquities_museum/app_screens/languages_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:antiquities_museum/model/shared_preferences.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    handleAppData(context);
  }

  void handleAppData(context) async {
    var lang = await getLanguagePreference();
    //print("lang: $lang");

    if(lang != null){
      appData.lang = lang;
      var isData = await getAppData();
      //print("Collections: ${appData.Collections}");

      if(isData){
        Timer(const Duration(milliseconds: 2500), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
        });
      }
    } else {
      Timer(const Duration(milliseconds: 3500), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LanguagesScreen(isStart: true,)));
      });
    }


  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/comp/splash_bg.png"), // Path to your image asset
            fit: BoxFit.fitHeight, // This will fill the screen
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logos/app_animi_puls_logo.gif', width: width * .9),
            Image.asset('assets/images/comp/splash_text.png', width: width * .95),

            const SizedBox(height: 20),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xff021930))),
          ],
        ),
      ),
    );
  }
}
