import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../models/badge_system.dart';
import '../api/api_service.dart';

class ChatScreen extends StatefulWidget { const ChatScreen({super.key}); @override State<ChatScreen> createState() => _ChatScreenState(); }
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _c = TextEditingController();
  final List<Map<String, String>> _msgs = [{"role": "ai", "text": "Hi! I am Nova. Tap the mic to speak, or type a message!"}];
  
  // Voice Engines
  final FlutterTts _tts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  
  bool _isLoading = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _tts.setLanguage("en-IN"); // Default to Indian English
    _tts.setSpeechRate(0.5);
  }

  // MICROPHONE FUNCTION
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(onStatus: (val) => print('onStatus: $val'), onError: (val) => print('onError: $val'));
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) => setState(() => _c.text = val.recognizedWords));
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  // SEND & SPEAK FUNCTION
  void _send() async {
    if (_c.text.isEmpty) return;
    String text = _c.text; _c.clear();
    setState(() { _msgs.add({"role": "user", "text": text}); _isLoading = true; });
    context.read<GameManager>().addXP(20); 
    
    String reply = await ApiService.sendChatMessage(text);
    setState(() { _msgs.add({"role": "ai", "text": reply}); _isLoading = false; });
    
    // Actually speak the reply!
    await _tts.speak(reply);
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
                  color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey.shade100,
                  border: isMe ? null : Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe) IconButton(icon: const Icon(Icons.volume_up, color: Colors.blue), onPressed: () => _tts.speak(_msgs[i]['text']!)),
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
            CircleAvatar(radius: 25, backgroundColor: Theme.of(context).colorScheme.primary, child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _send))
          ]),
        )
      ]),
    );
  }
}
