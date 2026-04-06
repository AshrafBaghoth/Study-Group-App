import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AiStudy extends StatefulWidget {
  const AiStudy({super.key});

  @override
  State<AiStudy> createState() => _AiStudyState();
}

class _AiStudyState extends State<AiStudy> {
  late final GenerativeModel chatModel;
  late final ChatSession chatSession;
  TextEditingController chatInput = TextEditingController();
  List<String> messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
    chatModel = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: 'AIzaSyD4NaXwHsB6CcYL3ZGosk8QTSJAlJtNT2E',
      systemInstruction: Content('system', [
        TextPart(
          'Answer all questions related to education in Aden, and also general academic subjects like math, science, and language. '
          'Also answer all questions related to sports in Aden. '
          'If you are asked about anything else, always reply: "I am not programmed for this."',
        ),
      ]),
    );
    chatSession = chatModel.startChat();
  }

  
  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('ai_study_messages', messages);
  }

  
  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getStringList('ai_study_messages');
    if (savedMessages != null) {
      setState(() {
        messages = savedMessages;
      });
    }
  }

  
  Future<void> generateChatOutput(String msg) async {
    if (msg.trim().isEmpty) return;
    setState(() {
      messages.add('ME: $msg');
    });
    await _saveMessages(); 

    chatInput.clear();
    final message = Content('user', [TextPart(msg)]);
    final response = await chatSession.sendMessage(message);

    final reply = response.text ?? '...';
    setState(() {
      messages.add('AI: $reply');
    });
    await _saveMessages(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: ClipOval(
          child: Image.asset(
            'images/sai.png',
            height: 50,
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            bool isUser = messages[index].startsWith('ME:');
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isUser ? Colors.brown: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  messages[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          controller: chatInput,
          decoration: InputDecoration(
            hintStyle: const TextStyle(color: Colors.white70),
            hintText: 'Ask Me',
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.brown),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(20),
            ),
            suffixIcon: IconButton(
              onPressed: () {
                generateChatOutput(chatInput.text);
              },
              icon: const Icon(Icons.send, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
