import 'package:cloud_firestore/cloud_firestore.dart';

class AppData {
  String lang;
  var Collections;

  AppData({
    required this.lang,
    required this.Collections,
  });

  void clear() {
    Collections.clear();
  }
}

var appData = AppData(
  lang: '',
  Collections: [],
);

Future<bool> getAppData() async {
  appData.clear();
  appData.Collections = await fetchCollections();
  return true;

}

Future<List<Map<String, dynamic>>> fetchCollections() async {
  try {
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('Collections').get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    // Handle the exception (e.g., no internet connection, invalid collection name)
    print('Error fetching data: $e');
    return []; // Return an empty list or handle the error as needed
  }
}

