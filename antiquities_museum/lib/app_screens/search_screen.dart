import 'package:antiquities_museum/app_screens/antique_screen.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends SearchDelegate<String> {
  SearchScreen() : super(
    searchFieldLabel: "Type here to search",
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  ) {
    fetchAntiques();  // Call fetchAntiques inside the constructor body
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _antiquesData = [];
  var lang= appData.lang;




  void fetchAntiques() async {
    var snapshot = await _firestore.collection('Antiques').get();
    _antiquesData = snapshot.docs
        .map((doc) {
      var name = lang == 'ar'? doc.data()["name_ar"] :
      lang == 'es'? doc.data()["name_es"] :
      lang == 'de'? doc.data()["name_de"] :
      doc.data()["name_en"];
      return {
        'name': name as String ?? '',
        'images': List.from(doc.data()['images'] ?? [])
      };
    })
        .toList();
  }





  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffF1F8FD),

      ),
      scaffoldBackgroundColor: const Color(0xffF1F8FD),

    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? _antiquesData
        : _antiquesData.where((antique) {
      return (antique['name'] as String).toLowerCase().startsWith(query.toLowerCase());
    }).toList();

    if(suggestionList.isEmpty){
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(55),
          child: Text(
            lang == 'ar'? "لم يتم العثور على بيانات" :
            lang == 'es'? "No se encontraron datos" :
            lang == 'de'? "Keine Daten gefunden" :
            "No data Found",
            style: const TextStyle(
              fontSize: 14,
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
    else{
      return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          var data = suggestionList[index];
          var firstImage = data['images'].isNotEmpty ? data['images'][0] : 'https://via.placeholder.com/150'; // Placeholder image
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: ListTile(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AntiqueScreen(antiqueData: data),
                  ),
                );
              },
              leading: lang != "ar" ? Container(
                width: 50,
                height: 50,
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
                    firstImage,
                    width: 50,
                    height: 50,
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
              ) : null,
              title: RichText(
                text: TextSpan(
                  text: data['name'].substring(0, query.length),
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: data['name'].substring(query.length),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                textAlign: lang == 'ar'? TextAlign.end : TextAlign.start,
              ),
              trailing: lang == "ar" ?  Container(
                width: 50,
                height: 50,
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
                    firstImage,
                    width: 50,
                    height: 50,
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
              ) : null,
            ),
          );
        },
      );

    }
  }

}
