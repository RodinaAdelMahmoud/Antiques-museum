import 'package:antiquities_museum/app_screens/splash_screen.dart';
import 'package:antiquities_museum/app_screens/user_menu_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:antiquities_museum/model/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    'https://s3-alpha-sig.figma.com/img/f1d6/d578/8b92c2fa9436a67218f11d1c71b93b66?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ji0LXA1Ph5OP3PLL1Kb5UwPgDa36eApgBLsQruzp0VrT4ClimXhSGmY6EffzzcVb5H8RAk-kHfL8VvpugnVjmWKS3rVow3xLu44FUZF6vKlNzPCd43ZSTA8xquOQuFyhfKjqJHceQRSrCtoY~q8144t53rZv0pTVW-04SJ~X-19~n-ynTXHqchT5SCZj4WTTNNgxljnybuPvTvhwrX4n9kiN0sQnP0r5G1zatK4kU~lPGn6EMXTMdYNSkLewZoc0aLKp8w2WQM3gLrP0n6PEcIPOtFUAsRU-udQW4ECkX~tpV-zzAQl-8SeCqxhLN2718O-Tp11vOquODmHxWcZjOw__',
    'https://s3-alpha-sig.figma.com/img/910a/f9d2/ae469863151beed444b2e59e9785939a?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=UCIpL8qEWbUpsdkh9IZp~29ymXxEN1zKKbXmcLGig~e1rZ18dYhkXoU5Q5YddH90lK0CitftrnCZ-CQomZV7DaegJ5pApORcSwURzH3HImf8Lj6wxaqCBcDCtxAdOWmLCxE0~5O6pOg6pctT9BYqQeAGsyxvrPxLh0e3eGbnlc93A2ogFQIdKJloEq8YAZh2hAx8rBX~wY5E2l-B3wQNFGrhAQEHXwkZFlZfBYQOsV~xwvsZyMPXblnDxVz9djhb-wgFn4h9DAGEeCh1q~2uqRhckU~4zWxpFZGCmYPWmTN2Y8dCR3UgM7RkcMKGRHy9SoUw-BCyaxfzjSc1Oe~loA__',
    'https://s3-alpha-sig.figma.com/img/cdd6/bbf1/daf7348572c5e599d57cbc396618d9f5?Expires=1718582400&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=IFJk8jgNh2xr29zGJfUE9EOIA4MKHnc5BrhQ~E8J9JX4wStYnyOsr7WdnLs89lX3xi-hrOyy~BuGErK~WiBNnqLFM42GhUKmuDluFeg45-U20DbreyuR3B2MqHd2Plsg65Y5ygXvyt5x6mU1l4agus65Yov0qpH3fs93LLL18WVZtTY-XXYeLNjLhnmKgc-mh82A7pn9RHZXauYTDJq~37JdCTSUp9rE~YHCvkX5aKOREiBQZyxRVBvuvMzUDZpg1JxTh~hG1Kt7a123q5qpzD8P4d7aw7MBywyv044KFeqOGlllOQO-CYoE8~ogwNkFB2gY1rJbn9UrXn~YtzVnOA__',
  ];


  List<Map<String, dynamic>> collections = [];


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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
                    // Action on press
                    print('Icon tapped!');
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
                              errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image), // Fallback for image errors
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
                                  child: Container(
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
                                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image), // Fallback for image errors
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
                                  errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image), // Fallback for image errors
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
    );
  }


}
