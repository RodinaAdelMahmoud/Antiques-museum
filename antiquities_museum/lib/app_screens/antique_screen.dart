
import 'dart:ui';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';


class AntiqueScreen extends StatefulWidget {
  final antiqueData;

  AntiqueScreen({Key? key, required this.antiqueData}) : super(key: key);

  @override
  _AntiqueScreenState createState() => _AntiqueScreenState();
}

class _AntiqueScreenState extends State<AntiqueScreen> {
  var _antiqueName;
  var _antiqueDes;
  var _antiqueAge;
  var _antiqueImages = [];


  int _currentIndex = 0;

  var _button = '';
  var _title = '';
  var _des = '';
  var _age = '';

  @override
  void initState() {
    super.initState();

    var data = widget.antiqueData;
    _antiqueImages= data['images'];

    if(appData.lang == 'en'){
      _antiqueName = data['name_en'] ?? '';
      _antiqueDes = data['description_en'] ?? '';
      _antiqueAge = data['age_en'] ?? '';

      _button = 'More with ChatBot';
      _title = 'Antique Title:';
      _des = 'Antique Description:';
      _age = 'Antique Age:';
    }
    else if(appData.lang == 'ar'){
      _antiqueName = data['name_ar'] ?? '';
      _antiqueDes = data['description_ar'] ?? '';
      _antiqueAge = data['age_ar'] ?? '';

      _button = 'المزيد مع الدردشة الآلية';
      _title = ':اسم القطعة الأثرية';
      _des = ':وصف القطعة الأثرية';
      _age = ':تاريخ القطعة الأثرية';

    }
    else if(appData.lang == 'es'){
      _antiqueName = data['name_es'] ?? '';
      _antiqueDes = data['description_es'] ?? '';
      _antiqueAge = data['age_es'] ?? '';

      _button = 'Más con ChatBot';
      _title = 'Título de la Reliquia:';
      _des = 'Descripción de la Reliquia:';
      _age = 'Época de la Reliquia:';


    }
    else if(appData.lang == 'de'){
      _antiqueName = data['name_de'] ?? '';
      _antiqueDes = data['description_de'] ?? '';
      _antiqueAge = data['age_de'] ?? '';

      _button = 'Mehr mit ChatBot';
      _title = 'Titel des Antiquitäts:';
      _des = 'Beschreibung des Antiquitäts:';
      _age = 'Zeitalter des Antiquitäts:';


    }


    print(_antiqueName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F8FD),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),  // Set this to whatever height you need
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),  // Apply rounded corners
          child: AppBar(
            backgroundColor: const Color(0xffF1F8FD),
            elevation: 8,  // Removes shadow
            title: Text(_antiqueName,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: 'Serif',
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: Offset(1.5, 1.5),
                    blurRadius: 3.0,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 1.8,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.8,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: _antiqueImages
                        .map((item) => Center(
                      child: GestureDetector(
                        onTap: () => showImageDialog(context, item),
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
                      ),
                    ))
                        .toList(),

                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _antiqueImages.map((url) {
                      int index = _antiqueImages.indexOf(url);
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
              ),
            ), //photo slider
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15),

              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: appData.lang == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      Text(_title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Serif',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_antiqueName,
                    style: const TextStyle(
                      fontSize: 22,
                      fontFamily: 'Serif',
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )

                ],
              ),
            ), //title
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15),

              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                   Row(
                     mainAxisAlignment: appData.lang == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                     children: [
                      Text(_age,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Serif',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_antiqueAge,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Serif',
                      color: Colors.black,
                      shadows: [
                        Shadow(
                          offset: Offset(1.5, 1.5),
                          blurRadius: 3.0,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,

                  )

                ],
              ),
            ), //age
            const SizedBox(height: 20),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(2, 2), // changes position of shadow
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              child: Column(
                children: [
                   Row(
                     mainAxisAlignment: appData.lang == "ar" ? MainAxisAlignment.end : MainAxisAlignment.start,
                     children: [
                      Text(_des,
                        style: const TextStyle(
                          fontSize: 16,
                          fontFamily: 'Serif',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_antiqueDes,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.7),
                    ),
                    textAlign: TextAlign.center,

                  )

                ],
              ),
            ), //description
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed:(){},
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                ),
                padding: MaterialStateProperty.all(EdgeInsets.zero), // Override padding for custom alignment
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D77BB), Color(0xFF98BDE9)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Container(
                  width: 220,
                  constraints: const BoxConstraints(minWidth: 88, minHeight: 36), // Minimum touch target size per Material guidelines
                  alignment: Alignment.center,
                  child: Text(_button, style: const TextStyle(fontFamily: 'Serif',fontSize: 17),),
                ),
              ),
            ),
            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }
}

void showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(10),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5), // Adjust blur effect to your liking

            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              backgroundDecoration: BoxDecoration(
                color: Colors.transparent,
              ),
              minScale: PhotoViewComputedScale.contained * 1,
              maxScale: PhotoViewComputedScale.covered * 2,
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
              loadingBuilder: (context, event) {
                if (event == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                double progress = event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 1);
                return Center(
                  child: CircularProgressIndicator(value: progress),
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 30,),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}
