
import 'package:antiquities_museum/app_screens/antique_screen.dart';
import 'package:antiquities_museum/app_screens/search_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class galleryScreen extends StatefulWidget {


  galleryScreen({Key? key,}) : super(key: key);

  @override
  _galleryScreenState createState() => _galleryScreenState();
}

class _galleryScreenState extends State<galleryScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> _antiquesStream;
  var _collectionsList;

  var lang;

  @override
  void initState() {
    super.initState();
    // Initialize the stream
    lang = appData.lang;
    _collectionsList = appData.Collections;
    //print("_collectionsList: $_collectionsList");

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
            title: Text(lang == 'ar'? 'المعرض' : lang == 'es'? 'Galería' : lang == 'de'? 'Galerie' : "Gallery",
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
              ),),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(onPressed: (){
                  showSearch(context: context, delegate: SearchScreen());
                }, icon: const Icon(Icons.search)),
              )
            ],
          ),
        ),
      ),
      body:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _collectionsList.length,
          itemBuilder: (context, index) {
            String collName = lang == 'ar'? _collectionsList[index]['name_ar'] :
                              lang == 'es'? _collectionsList[index]['name_es'] :
                              lang == 'de'? _collectionsList[index]['name_de'] :
                              _collectionsList[index]['name_en'] ?? 'No Name Available';
            String collId = _collectionsList[index]['collection_id'] ?? 'No Name Available';

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Column(
                crossAxisAlignment: lang == 'ar'? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(collName,
                    style: const TextStyle(
                      fontSize: 20,
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
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('Antiques')
                        .where('collection_id', isEqualTo: collId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: Container(
                          margin: const EdgeInsets.all(35.0),
                          child: const CircularProgressIndicator(),
                        ));
                      }
                      if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                        return Container(
                          height: 350,
                          child: ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            scrollDirection: Axis.horizontal,
                            reverse: lang == 'ar'? true : false,
                            itemBuilder: (context, index) {
                              var doc = snapshot.data!.docs[index];
                              var data = doc.data() as Map<String, dynamic>;
                              var antiqueimage = data['images'][0] ?? '';
                              var antiqueName = lang == 'ar'? data['name_ar'] :
                                                lang == 'es'? data['name_es'] :
                                                lang == 'de'? data['name_de'] :
                                                data['name_en'] ?? '';
                              var antiqueAge = lang == 'ar'? data['age_ar'] :
                                               lang == 'es'? data['age_es'] :
                                               lang == 'de'? data['age_de'] :
                                               data['age_en'] ?? '';

                              return InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AntiqueScreen(antiqueData: data),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 280,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  margin: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      const BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 3,
                                        blurRadius: 5,
                                        offset: Offset(2, 2), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(15),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(2, 2), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            antiqueimage,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image), // Fallback for image errors
                                            loadingBuilder: (BuildContext context, Widget child,
                                                ImageChunkEvent? loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: CircularProgressIndicator(
                                                    color: const Color(0xFF131A5C),
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                        loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ), // Antique Image
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                "$antiqueName",
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black87,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 2.0,
                                                      color: Colors.black26,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ), // Antique Name
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 12),
                                              child: Text(
                                                antiqueAge,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  shadows: [
                                                    Shadow(
                                                      offset: Offset(1.0, 1.0),
                                                      blurRadius: 2.0,
                                                      color: Colors.black26,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ), // Antique Age
                                          ],
                                        ),
                                      ), // Antique Name&Age

                                    ],
                                  ),
                                ),
                              ); // Antique View Card
                            },
                          ),
                        ); // Antique Cards
                      }
                      else{
                        // No data found
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(55),
                            child: Text(
                              lang == 'ar'? "لم يتم العثور على بيانات" :
                              lang == 'es'? "No se encontraron datos" :
                              lang == 'de'? "Keine Daten gefunden" :
                              "No data Found",
                              style: const TextStyle(
                                fontSize: 13,
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
                          ),
                        );
                      }
                    },
                  ), //Collections
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
