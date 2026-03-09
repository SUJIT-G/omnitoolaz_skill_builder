import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import '../models/badge_system.dart';
import '../api/api_service.dart';

class ChatScreen extends StatefulWidget { const ChatScreen({super.key}); @override State<ChatScreen> createState() => _ChatScreenState(); }
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _c = TextEditingController();
  final List<Map<String, String>> _msgs = [{"role": "ai", "text": "Hi! I am Nova. Let's speak English, Hindi, or Bengali! Tap the mic to talk."}];
  
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  bool _isLoading = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  // Safely initialize speaker
  void _initTts() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
  }

  // Safely trigger speaker
  void _speak(String text) async {
    try {
      await _tts.speak(text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Could not play audio.")));
    }
  }

  // Safely trigger microphone with permissions popup
  void _listen() async {
    // 1. Force the Android Permission Popup!
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Microphone permission denied!")));
      return;
    }

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) { if (val == 'done') setState(() => _isListening = false); },
        onError: (val) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mic Error: \${val.errorMsg}"))),
      );
      
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() { _c.text = val.recognizedWords; });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Your phone does not support Speech-to-Text.")));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _send() async {
    if (_c.text.isEmpty) return;
    String text = _c.text; _c.clear();
    setState(() { _msgs.add({"role": "user", "text": text}); _isLoading = true; });
    context.read<GameManager>().addXP(20); 
    
    String reply = await ApiService.sendChatMessage(text);
    setState(() { _msgs.add({"role": "ai", "text": reply}); _isLoading = false; });
    
    // Auto-speak AI reply
    _speak(reply);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speak with Nova AI'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 1),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _msgs.length,
          itemBuilder: (c, i) {
            bool isMe = _msgs[i]['role'] == 'user';
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF58CC02) : Colors.grey.shade100,
                  border: isMe ? null : Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe) IconButton(icon: const Icon(Icons.volume_up, color: Colors.blue), onPressed: () => _speak(_msgs[i]['text']!)),
                    if (!isMe) const SizedBox(width: 8),
                    Flexible(child: Text(_msgs[i]['text']!, style: TextStyle(color: isMe ? Colors.white : Colors.black87, fontSize: 16))),
                  ],
                ),
              ),
            );
          },
        )),
        if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(children: [
            GestureDetector(
              onTap: _listen,
              child: CircleAvatar(radius: 25, backgroundColor: _isListening ? Colors.red : Colors.grey.shade200, child: Icon(Icons.mic, color: _isListening ? Colors.white : Colors.grey.shade700)),
            ),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _c, decoration: InputDecoration(hintText: "Type or speak...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)), contentPadding: const EdgeInsets.symmetric(horizontal: 20)))),
            const SizedBox(width: 12),
            CircleAvatar(radius: 25, backgroundColor: const Color(0xFF58CC02), child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _send))
          ]),
        )
      ]),
    );
  }
}
