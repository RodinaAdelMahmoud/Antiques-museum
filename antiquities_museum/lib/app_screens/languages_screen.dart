

import 'package:antiquities_museum/main.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:antiquities_museum/model/shared_preferences.dart';
import 'package:flutter/material.dart';

class LanguagesScreen extends StatefulWidget {
  final isStart;

  const LanguagesScreen({super.key, required this.isStart});

  @override
  State<LanguagesScreen> createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {

  bool isStart = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isStart = widget.isStart;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isStart ? null: const Color(0xffF1F8FD),
      appBar: isStart ? null:AppBar(
        backgroundColor: const Color(0xffF1F8FD),
      ),

      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration:isStart ? const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/comp/splash_bg.png"), // Path to your image asset
            fit: BoxFit.fitHeight, // This will fill the screen
          ),
        ):null,
        child: Column(
          children: [
            if(isStart)
              const SizedBox(height: 80),
              Text(isStart ?"Select Language" : (appData.lang == 'ar'? 'اختر اللغة' : appData.lang == 'es'? 'Seleccionar idioma' : appData.lang == 'de'? 'Sprache auswählen' : 'Select Language'),
                style: const TextStyle(
                fontSize: 30,
                fontFamily: 'Serif',
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: Offset(2.0, 2.0), // Offset for shadow position
                    blurRadius: 3.0, // Blur radius for shadow
                    color: Colors.white70, // Shadow color
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
            const Center(
              child: Wrap(
                spacing: 40,
                runSpacing: 70,
                children: [
                  LanguageCard(
                    name: 'English',
                    imagePath: 'assets/images/comp/flags/english.png',
                  ), // English
                  LanguageCard(
                    name: 'العربيه',
                    imagePath: 'assets/images/comp/flags/arabic.png',
                  ), // Arabic

                  LanguageCard(
                    name: 'español',
                    imagePath: 'assets/images/comp/flags/spanish.png',
                  ), // Spanish
                  LanguageCard(
                    name: 'Deutsch',
                    imagePath: 'assets/images/comp/flags/germany.png',
                  ), // Germany
                ],
              ),
            ),
          ],
        ),),
    );
  }
}


class LanguageCard extends StatefulWidget {
  final String name;
  final String imagePath;

  const LanguageCard({super.key, required this.name, required this.imagePath});

  @override
  _LanguageCardState createState() => _LanguageCardState();
}

class _LanguageCardState extends State<LanguageCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("${widget.name} tapped");
        if(widget.name == "English"){
          await saveLanguagePreference("en");
        }
        else if(widget.name == "العربيه"){
          await saveLanguagePreference("ar");
        }
        else if(widget.name == "español"){
          await saveLanguagePreference("es");
        }
        else if(widget.name == "Deutsch"){
          await saveLanguagePreference("de");
        }
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => MyApp(local: appData.lang)));

      },
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: Container(
        width: 150, // Adjust size as needed
        height: 150,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFD9E6FF), Color(0xFF1E3050), ],
            stops: [0.0, 1.0],
          ),
          border: Border.all(
            color: const Color(0xFFB8B8B8),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 4),
              blurRadius: 4,
            ),
          ],
          borderRadius: BorderRadius.circular(45),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child: Image.asset(widget.imagePath, width: 70, height: 70,)
            ),
            const SizedBox(height: 10),
            Text(
              widget.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}