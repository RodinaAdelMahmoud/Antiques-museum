import 'package:antiquities_museum/app_screens/antique_screen.dart';
import 'package:antiquities_museum/app_screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/app_data.dart';

class CollectionScreen extends StatefulWidget {
  final String collectionId;
  final String title;

  const CollectionScreen({super.key, required this.collectionId, required this.title});

  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  late Stream<QuerySnapshot> _antiquesStream;
  var lang;


  @override
  void initState() {
    super.initState();
    // Initialize the stream
    lang = appData.lang;

    _antiquesStream = FirebaseFirestore.instance
        .collection('Antiques')
        .where('collection_id', isEqualTo: widget.collectionId)
        .snapshots();
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
            elevation: 8,
            centerTitle: true,
            title: Text(widget.title,
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
      body: StreamBuilder<QuerySnapshot>(
        stream: _antiquesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text(
              "Something went wrong\nPlease try again later",
              style: TextStyle(
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
            ),);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            // Handle the data of the stream
            return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              var name ;
              var des;
              var image = data['images'][0] ?? '';

              //print(image);
              if(lang == 'en'){
                name = data['name_en'] ?? '';
                des = data['description_en'] ?? '';
              }
              else if(lang == 'ar'){
                name = data['name_ar'] ?? '';
                des = data['description_ar'] ?? '';
              }
              else if(lang == 'es'){
                name = data['name_es'] ?? '';
                des = data['description_es'] ?? '';
              }
              else if(lang == 'de'){
                name = data['name_de'] ?? '';
                des = data['description_de'] ?? '';
              }

              return  Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFEEEEEE),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(2, 2), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
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
                            image,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Center(child: const Icon(Icons.broken_image)), // Fallback for image errors
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
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: lang == "ar" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(1.0, 1.0),
                                  blurRadius: 2.0,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              des,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              textAlign: lang == "ar" ? TextAlign.end : TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,

                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AntiqueScreen(antiqueData: data),
                                    ),
                                  );
                                },
                                child: Text(
                                  lang == 'ar'? 'المزيد من التفاصيل' : lang == 'es'? 'Ver más' : lang == 'de'? 'Mehr sehen' : 'see more',
                                  style: const TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            );
          }
          else{
            // No data found
            return Center(
              child: Text(
                lang == 'ar'? "لم يتم العثور على بيانات" :
                lang == 'es'? "No se encontraron datos" :
                lang == 'de'? "Keine Daten gefunden" :
                "No data Found",
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
            );
          }
        },
      ),
    );
  }

}
