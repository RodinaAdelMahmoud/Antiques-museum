import 'dart:convert';
import 'package:http/http.dart' as http;

// VoiceflowService for handling API requests to Voiceflow
class VoiceflowService {
  final String apiKey = 'VF.DM.66229512fba3874f388a3513.dpKTHgkcW2QR8vbd';
  final String versionID = '6622897deada87613dc1b04c';
  final String baseUrl = 'https://general-runtime.voiceflow.com';

  Future<Map<String, dynamic>> sendMessage(String userMessage) async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/state/$versionID/user/messages'),
        headers: {
          'Authorization': apiKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': {
            'type': 'text',
            'payload': userMessage,
          },
        }),
      );

      if (response.statusCode == 200) {
        print("response body: ${response.body}");


        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send message: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to connect to the service: $e');
    }
  }
}
