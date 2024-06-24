import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:antiquities_museum/model/GeminiAIService.dart';
import 'package:antiquities_museum/model/app_data.dart';
import 'package:http/http.dart' as http;

class ChatBotScreen extends StatefulWidget {
  final text;
  final image;
  final bool isSerch;

  const ChatBotScreen({super.key, required this.isSerch, this.text, this.image});
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> with SingleTickerProviderStateMixin {
  late AnimationController _anmicontroller;
  late List<Animation<double>> _animations;

  final GenerativeAIService _googleGeni = GenerativeAIService();
  List<Map<String, dynamic>> messages = [];
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<File> _selectedImages = [];
  bool _isSending = false;
  final FocusNode _focusNode = FocusNode();

  String welMsg = appData.lang =='en' ? "**Welcome!** I'm here to help you learn more about our museum. Ask me anything!":
  appData.lang =='ar' ? "أهلاً وسهلاً! أنا هنا لمساعدتك على معرفة المزيد عن متحفنا. اسألني أي شيء!":
  appData.lang =='es' ? "¡Bienvenido! Estoy aquí para ayudarte a aprender más sobre nuestro museo. ¡Pregúntame cualquier cosa!":
  "Willkommen! Ich bin hier, um Ihnen mehr über unser Museum zu erzählen. Fragen Sie mich alles!";


  @override
  void initState() {
    super.initState();
    _anmicontroller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _anmicontroller,
          curve: Interval(
            index * 0.2,
            1.0,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });

    _anmicontroller.repeat(reverse: true);

    _focusNode.addListener(_focusNodeListener);

   _handleData();
  }

  @override
  void dispose() {
    _anmicontroller.dispose();
    _msgController.dispose();
    super.dispose();
  }

  _handleData() async {

     if(widget.isSerch){
      final imageFile = await downloadImage(widget.image);
      _selectedImages.add(File(imageFile.path));
      _msgController.text = widget.text;
      sendMessage();
    }else{
      messages.add({"text": welMsg, "isUser": false,});
      _googleGeni.addToHistory(welMsg);
    }
  }

  void sendMessage() async {
    String text = _msgController.text;

    if (text.isEmpty && _selectedImages.isEmpty) return;
    setState(() {
      messages.add({"text": text, "isUser": true, "images": List.from(_selectedImages)});
      _isSending = true;
      _msgController.clear();
    });
    _scrollToBottom();

    String responseText;
    print('_selectedImages.isEmpty: ${_selectedImages.isEmpty}');

    if (_selectedImages.isNotEmpty) {
      responseText = await _googleGeni.generateTextFromMultimodal(text, _selectedImages);
    } else {
      responseText = await _googleGeni.generateTextFromText(text);
    }
    setState(() {
      messages.add({"text": responseText, "isUser": false});
      _selectedImages.clear();
      _isSending = false;
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + MediaQuery.of(context).size.height,
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    }
  }

  void _focusNodeListener() {
    if (_focusNode.hasFocus) {
      _scrollToBottom();
    }
  }

  Future<File> downloadImage(String imageUrl) async {
    try {
      // Making a HTTP GET request to the image URL
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        // Creating a temporary file
        // This file will be deleted when the app is closed
        final file = File('${Directory.systemTemp.path}/${imageUrl.split('/').last}');
        // Writing the file with the image bytes
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        throw Exception('Failed to download image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to download image: $e');
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
            title: Text(appData.lang == 'ar' ? 'روبوت المحادثة' : "ChatBot",
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
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
            _scrollToBottom();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Column(
                    children: [
                      ListTile(
                        title: Align(
                          alignment: message['isUser'] ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: message['isUser'] ? Colors.blue : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for (var img in message['images'] ?? [])
                                  Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(img)
                                    ),
                                  ),
                                  message['isUser'] ?
                                  Text(
                                    message['text'],
                                    style: const TextStyle(color: Colors.white,fontSize: 15),
                                    textAlign: appData.lang =='ar' ? TextAlign.left : TextAlign.right,
                                  ):
                                  RichText(
                                    text: TextSpan(
                                      style: const TextStyle(color: Colors.black, fontSize: 15),
                                      children: parseMarkdown(message['text']),
                                    ),
                                    textAlign:appData.lang =='ar' ? TextAlign.right : TextAlign.left,

                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (_isSending && messages.length - 1 == index )
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Container(
                                margin: const EdgeInsets.all(10.0),
                                alignment: Alignment.centerLeft,
                                width: 90,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (index) {
                                    return AnimatedBuilder(
                                      animation: _animations[index],
                                      builder: (_, child) {
                                        return Container(
                                          width: 10,
                                          height: 10,
                                          margin: const EdgeInsets.symmetric(horizontal: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(_animations[index].value),
                                            shape: BoxShape.circle,
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),

            if (_selectedImages.isNotEmpty && !_isSending)
              SizedBox(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(_selectedImages[index]),
                          IconButton(
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                _selectedImages.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.image),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _msgController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        labelText: 'Chat with Gemini',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0), // Set the border radius here
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _pickImage() async {
    final ImageSource? source = await _showImageSourceDialog();
    if (source == null) return;  // User canceled the dialog

    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
      _scrollToBottom();
    }
  }

  Future<ImageSource?> _showImageSourceDialog() {
    return showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose image source'),
        content: const Text('Where would you like to get the image from?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Camera'),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text('Gallery'),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  List<TextSpan> parseMarkdown(String text) {
    List<TextSpan> spans = [];
    final lines = text.split('\n');
    bool isInList = false; // Track if we are processing a list

    for (var line in lines) {
      if (line.startsWith('* ')) {
        // Handle bullet points
        if (!isInList) {
          isInList = true; // Start of a new list
          spans.add(const TextSpan(text: '\n')); // Add a new line before starting a list
        }
        var lineContent = line.substring(2);
        spans.add(const TextSpan(text: '• ', style: TextStyle(fontWeight: FontWeight.bold)));
        spans.addAll(_parseInlineMarkdown(lineContent));
        spans.add(const TextSpan(text: '\n'));
      } else {
        isInList = false; // Not a list line
        spans.addAll(_parseInlineMarkdown(line));
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }

  List<TextSpan> _parseInlineMarkdown(String text) {
    List<TextSpan> inlineSpans = [];
    RegExp exp = RegExp(r'\*\*(.*?)\*\*');
    String remaining = text;

    while (exp.hasMatch(remaining)) {
      final match = exp.firstMatch(remaining)!;
      final beforeMatch = remaining.substring(0, match.start);
      final boldText = match.group(1)!;

      if (beforeMatch.isNotEmpty) {
        inlineSpans.add(TextSpan(text: beforeMatch));
      }
      inlineSpans.add(TextSpan(text: boldText, style: const TextStyle(fontWeight: FontWeight.bold)));
      remaining = remaining.substring(match.end);
    }

    if (remaining.isNotEmpty) {
      inlineSpans.add(TextSpan(text: remaining));
    }

    return inlineSpans;
  }
}
