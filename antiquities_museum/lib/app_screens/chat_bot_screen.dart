import 'package:antiquities_museum/model/app_data.dart';
import 'package:antiquities_museum/model/voiceflow_service.dart';
import 'package:flutter/material.dart';


class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final VoiceflowService _voiceflowService = VoiceflowService();
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _controller = TextEditingController();
  var lang = appData.lang;

  void sendMessage() async {
    String text = _controller.text;
    if (text.isEmpty) return;
    setState(() {
      messages.add({"text": text, "isUser": true});
      _controller.clear();
    });

    var response = await _voiceflowService.sendMessage(text);
    //print("response: $response");
    if (response.containsKey('message') && response['message'] is Map) {
      setState(() {
        messages.add({"text": response['stack'], "isUser": false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),  // Set this to whatever height you need
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),  // Apply rounded corners
          child: AppBar(
            backgroundColor: const Color(0xffF1F8FD),
            elevation: 8,  // Removes shadow
            title: Text(lang == 'ar'? 'روبوت المحادثة' : "ChatBot",
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
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]['isUser'];
                return ListTile(
                  title: Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      color: isUser ? Colors.blue : Colors.grey[300],
                      child: Text(
                        messages[index]['text'],
                        style: TextStyle(color: isUser ? Colors.white : Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Send a message',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
