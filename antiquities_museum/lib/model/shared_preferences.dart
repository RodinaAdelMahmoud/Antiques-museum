import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveLanguagePreference(String lang) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('lang', lang);
}


Future<String?> getLanguagePreference() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('lang'); // Returns null if 'lang' is not set
}


Future<void> clearAllPreferences() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // This will remove all data stored in SharedPreferences.
}