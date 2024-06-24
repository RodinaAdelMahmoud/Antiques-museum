import 'package:antiquities_museum/app_screens/museum_map_screen.dart';
import 'package:antiquities_museum/app_screens/splash_screen.dart';
import 'package:antiquities_museum/app_screens/user_menu_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var appName;
  var title1;
  var title2;


  int _currentIndex = 0;
  final List<String> banerList = [
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/baner_1-min.jpg?alt=media&token=0c29b36e-c66c-4bb4-b650-64f21d411181',
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/baner_1-min.jpg?alt=media&token=0c29b36e-c66c-4bb4-b650-64f21d411182',
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/baner_1-min.jpg?alt=media&token=0c29b36e-c66c-4bb4-b650-64f21d411183',
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/baner_1-min.jpg?alt=media&token=0c29b36e-c66c-4bb4-b650-64f21d411184',
  ];

  final List<String> activitiesList = [
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/images%2Factivities%2F1.jpg?alt=media&token=613a42c4-cb08-4638-afcf-48612dadb7f8',
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/images%2Factivities%2F2.jpg?alt=media&token=6ab52e41-e860-4419-b76b-f0406f2836bc',
    'https://firebasestorage.googleapis.com/v0/b/antiquities-museum.appspot.com/o/images%2Factivities%2F3.jpg?alt=media&token=9d15c518-1b59-4d80-bb95-0a9fb7f34966',
  ];


  List<Map<String, dynamic>> collections = appData.Collections;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collections = appData.Collections;
    //print('collections: $collections');
    //print('lang: ${appData.lang}');

    if(appData.lang == 'en'){
      appName = 'Antiques Museum';
      title1 = "Collections";
      title2 = "Other Activities";
    }
    else if(appData.lang == 'ar'){
      appName = 'متحف التحف';
      title1 = "مجموعات";
      title2 = "أنشطة أخرى";
    }
    else if(appData.lang == 'es'){
      appName = 'Museo de Antigüedades';
      title1 = "Colecciones";
      title2 = "Otras Actividades";
    }
    else if(appData.lang == 'de'){
      appName = 'Antiquitätenmuseum';
      title1 = "Sammlungen";
      title2 = "Weitere Aktivitäten";
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? lastPressed;

    var width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            lastPressed == null || now.difference(lastPressed!) > const Duration(seconds: 2);

        if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
          lastPressed = now;
          showExitWarning();
          return false;
        }

        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF1F8FD),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)), // Set the border radius here
            child: AppBar(
              elevation: 0,

              backgroundColor: const Color(0xffF1F8FD),
              leading: Builder(
                builder: (BuildContext context) {
                  return Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: IconButton(
                      icon: const Icon(Icons.menu, size: 30),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  );
                },
              ),
              title:  Text(appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Serif',
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      offset: Offset(2.5, 2.5),
                      blurRadius: 3.0,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              toolbarHeight: 80,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    icon: Image.asset('assets/images/comp/icons/map_icon.png', width: 50,height: 50,), // Replace 'your_icon.png' with your asset's name
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MuseumMap()),);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: const UserMenu(),

        body: Container(
          child: RefreshIndicator(
            onRefresh: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SplashScreen()),
              );
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlayInterval: const Duration(milliseconds: 3500),
                          autoPlayAnimationDuration: const Duration(milliseconds: 800),
                          autoPlay: false,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                          pauseAutoPlayOnTouch: true,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: banerList
                            .map((item) => Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(35)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              child:Image.network(
                                item,
                                fit: BoxFit.cover,
                                width: 1000,
                                errorBuilder: (context, error, stackTrace) => Center(child: const Icon(Icons.broken_image)), // Fallback for image errors
                                loadingBuilder: (BuildContext context, Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: const Color(0xFF131A5C),
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ))
                            .toList(),

                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: banerList.map((url) {
                          int index = banerList.indexOf(url);
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 800), // Duration of the color change
                            curve: Curves.linear, // Animation curve for the color change
                            width: 10.0,
                            height: 10.0,
                            margin: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentIndex == index
                                  ? const Color.fromRGBO(0, 0, 0, 0.9)
                                  : const Color.fromRGBO(0, 0, 0, 0.2),
                            ),
                            child: Transform.scale(
                              scale: _currentIndex == index ? 1.2 : 1.0, // Scale up if current index
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == index
                                      ? const Color.fromRGBO(0, 0, 0, 0.9)
                                      : const Color.fromRGBO(0, 0, 0, 0.2),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ), // Slider
                  const SizedBox(height: 20),

                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: appData.lang == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(title1,
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily: 'Serif',
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Colors.black26,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            child: Wrap(
                              spacing: 25,
                              runSpacing: 20,
                              children: collections.map((collection) {
                                var name ;
                                if(appData.lang == 'en'){
                                  name = collection['name_en'] ?? '';
                                }
                                else if(appData.lang == 'ar'){
                                  name = collection['name_ar'] ?? '';
                                }
                                else if(appData.lang == 'es'){
                                  name = collection['name_es'] ?? '';
                                }
                                else if(appData.lang == 'de'){
                                  name = collection['name_de'] ?? '';
                                }

                                return InkWell(
                                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CollectionScreen(collectionId: collection['collection_id']!, title: name,),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: width * 0.18,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: width * 0.18,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffF1F8FD),
                                            borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.2),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                                offset: const Offset(3, 5),
                                              ),
                                            ],
                                          ),
                                          child:Image.network(
                                            collection['icon_url']!,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for image errors
                                            loadingBuilder: (BuildContext context, Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  color: const Color(0xFF131A5C),
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(1.0, 1.0),
                                                blurRadius: 2.0,
                                                color: Colors.black26,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              ).toList(),

                            ),
                          ),
                        ],
                      )
                  ), // Collections
                  const SizedBox(height: 20),

                  Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: appData.lang == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(title2,
                              style: const TextStyle(
                                fontSize: 26,
                                fontFamily: 'Serif',
                                color: Colors.black,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2.0, 2.0), // Offset for shadow position
                                    blurRadius: 3.0, // Blur radius for shadow
                                    color: Colors.black26, // Shadow color
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 2.0,
                              enlargeCenterPage: false,
                              enableInfiniteScroll: false,
                              viewportFraction: 0.9,

                            ),
                            items: activitiesList
                                .map((item) => Center(
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),

                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(35)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5), // Adjust the shadow opacity
                                      blurRadius: 10, // Adjust the blur radius
                                      spreadRadius: 2, // Spread radius
                                      offset: const Offset(2, 2), // The X and Y offsets from the box
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  child:Image.network(
                                    item,
                                    fit: BoxFit.cover,
                                    width: 1000,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for image errors
                                    loadingBuilder: (BuildContext context, Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          color: const Color(0xFF131A5C),
                                          value: loadingProgress.expectedTotalBytes != null
                                              ? loadingProgress.cumulativeBytesLoaded /
                                              loadingProgress.expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ))
                                .toList(),

                          ),

                        ],
                      )
                  ), // other Activities
                  const SizedBox(height: 20),



                ],
              ),
            ),
          ),
        ),

        /*floatingActionButton: FloatingActionButton(
        onPressed: (){
          clearAllPreferences();
        },
      ),*/
      ),
    );
  }

  void showExitWarning() {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        right: 0,
        top: 0,
        bottom: 0,
        child: Material(
          color: Colors.transparent, // Semi-transparent grey background
          child: Center(
            child: Container(

              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.black.withOpacity(0.7), // Semi-transparent grey background
              ),
              child: const Text(
                'Double Tap Back Button to Exit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Remove the overlay after some time
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }


}
