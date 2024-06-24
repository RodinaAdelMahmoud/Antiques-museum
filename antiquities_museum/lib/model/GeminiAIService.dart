import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

class GenerativeAIService {
  late GenerativeModel model;
  final String apiKey = 'AIzaSyAzkV3DuFGjhWuYBnMiQazwlgjI5fxbF1k';
  final List<Content> _conversationHistory = [];

  var dataFeed = 'Name: Cairo Virtual Museum of Antiquities (CVMA);'
      ' Location: Virtual presence based in Cairo, Egypt;'
      ' Establishment Year: 2024;'
      ' Founder: Dr. Ahmed El Masry;'
      ' Main Focus: Egyptian Antiquities and Artifacts;'
      ' Collection Size: Features over 5,000 digitized artifacts from various dynasties;'
      ' Visitor Demographics: 45% from North America, 30% from Europe, 15% from the Middle East, 10% from other regions;'
      ' Popular Exhibits: The Virtual Tomb of Tutankhamun, The Royal Mummies Chamber, Artifacts from the Old Kingdom;'
      ' Educational Programs: Virtual Reality Tours for Schools, Monthly Webinars on Egyptology;'
      ' Technology Used: Advanced VR for immersive tours, AI-guided personalized tours, Interactive 3D models of artifacts;';

  GenerativeAIService() {
    addToHistory('help me to learn more about our museum, data:{$dataFeed}');
    model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    // data about our app musuem
  }
  void addToHistory(String text) {
    _conversationHistory.add(Content.text(text));
  }


  Future<String> generateTextFromText(String text) async {

    addToHistory(text);

    try {
      final response = await model.generateContent(_conversationHistory);
      if (response.text != null) {
        addToHistory(response.text!);
      }
      print('response: ${response.text}');

      return response.text ?? "No response generated.";
    } catch (e) {
      print('Failed to generate text: $e');
      return 'Error in generating text.';
    }
  }

  Future<String> generateTextFromMultimodal(String text, List<File> images) async {
    addToHistory(text); // Only text is added to history for context

    //print('image path: ${images[0].path}');
    final prompt = TextPart(text);
    var list = [prompt];
    List<DataPart> imageParts = [];
    for (var image in images) {
      var imageData = await image.readAsBytes();
      imageParts.add(DataPart('image/jpeg', imageData));
    }

    try {
      final response = await model.generateContent([
        Content.multi([prompt, ...imageParts])
      ]);
      addToHistory(response.text!);
      return response.text ?? "No response generated.";
    } catch (e) {
      print('Failed to generate multimodal content: $e');
      return 'Error in generating multimodal content.';
    }
  }

}
