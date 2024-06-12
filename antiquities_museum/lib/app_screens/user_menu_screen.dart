import 'dart:ui';

import 'package:antiquities_museum/app_screens/chat_bot_screen.dart';
import 'package:antiquities_museum/app_screens/gallery_screen.dart';
import 'package:antiquities_museum/app_screens/home_screen.dart';
import 'package:antiquities_museum/app_screens/languages_screen.dart';
import 'package:antiquities_museum/app_screens/museum_map_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:flutter/material.dart';






class UserMenu extends StatefulWidget {
  const UserMenu({super.key});

  @override
  State<UserMenu> createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {


  var lang;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    lang = appData.lang;
    //print(lang);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:Colors.transparent,
      elevation: 16,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),

        child: Container(
          color: Colors.black.withOpacity(.4),  // 70% opacity applied to a light grey color

          child: SingleChildScrollView(
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),

              Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      flex:7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),

                        child: Text(lang == 'ar' ? 'دليل\nالمتحف' : lang == 'es'? 'Guía\ndel Museo' : lang == 'de'? 'Museumsführer' : 'Museum\nGuide',
                        style: TextStyle(
                          color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 24,
                            letterSpacing: 6),
                        ),
                      ),
                    ),
                    const SizedBox(width: 7),
                    Expanded(
                      flex:2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                     size: 30, color: Color(0XFFFFFFFF)
                              ),
                              onPressed: (){
                                Navigator.of(context).pop();
                              }),
                          ],
                      ),
                    ),
                  ],
                ),
              ), // menu bar
              const SizedBox(
                height: 30,
              ),

              Container(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeScreen()),);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Icon(Icons.home_outlined, color: Color(0XFFD0C291), size: 28,),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(lang == 'ar'? 'الرئيسية' : lang == 'es'? 'Inicio' : lang == 'de'? 'Startseite' : "Home",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'times'
                                )),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios_sharp,
                                size: 18, color: Color(0XFFFFFFFF)),
                          ),
                        ],
                      ),
                    ), // Home page
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => galleryScreen()),);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Icon(Icons.photo_album, color: Color(0XFFD0C291), size: 28,),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(lang == 'ar'? 'المعرض' : lang == 'es'? 'Galería' : lang == 'de'? 'Galerie' : "Gallery",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'times'
                                )),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios_sharp,
                                size: 18, color: Color(0XFFFFFFFF)),
                          ),
                        ],
                      ),
                    ), // Gallery page
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MuseumMap()),);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Icon(Icons.map, color: Color(0XFFD0C291), size: 28,),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(lang == 'ar'? 'خريطة المتحف' : lang == 'es'? 'Mapa' : lang == 'de'? 'Karte' : "Map",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'times'
                                )),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios_sharp,
                                size: 18, color: Color(0XFFFFFFFF)),
                          ),
                        ],
                      ),
                    ), // Map page
                    const SizedBox(height: 30),
                    InkWell(
                      onTap: () async {
                        Navigator.of(context).pop();
                        await Future.delayed(Duration(milliseconds: 100));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatBotScreen()),);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child:
                            Icon(Icons.chat, color: Color(0XFFD0C291), size: 28,),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(lang == 'ar'? 'روبوت المحادثة' : "ChatBot",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'times'
                                )),
                          ),
                          Expanded(
                            child: Icon(Icons.arrow_forward_ios_sharp,
                                size: 18, color: Color(0XFFFFFFFF)),
                          ),
                        ],
                      ),
                    ), // ChatBot page


                  ],
                ),
              ), // menu pages
              const SizedBox(
                height: 20,
              ),

              Container(
                height: 50,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Future.delayed(Duration(milliseconds: 100));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LanguagesScreen(isStart: false,)),);
                  },
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.translate,
                            color: Color(0XFF374151)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(lang == 'ar'? 'اللغه' : lang == 'es'? 'IdiomaIdioma' : lang == 'de'? 'Sprache' : "Language" ,
                            style: TextStyle(
                                color: Color(0XFF374151),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'times'
                            )),
                      ),
                      Expanded(
                        child:
                        Icon(Icons.arrow_forward_ios_sharp, size: 20, color: Color(0XFF374151)),
                      ),
                    ],
                  ),
                ),
              ), // language page
              const SizedBox(
                height: 20,
              ),

            ]),
          ),
        ),
      ),
    );
  }




}
