import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/badge_system.dart';
import '../api/api_service.dart';

class ChatScreen extends StatefulWidget { const ChatScreen({super.key}); @override State<ChatScreen> createState() => _ChatScreenState(); }
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _c = TextEditingController();
  final List<Map<String, String>> _msgs = [{"role": "ai", "text": "Hi! I am your AI. Let's practice English!"}];
  bool _isLoading = false;

  void _send() async {
    if (_c.text.isEmpty) return;
    String text = _c.text; _c.clear();
    setState(() { _msgs.add({"role": "user", "text": text}); _isLoading = true; });
    context.read<GameManager>().addXP(5); // Gamification!
    
    String reply = await ApiService.sendChatMessage(text);
    setState(() { _msgs.add({"role": "ai", "text": reply}); _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('English Chat')),
      body: Column(children: [
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16), itemCount: _msgs.length,
          itemBuilder: (c, i) {
            bool isMe = _msgs[i]['role'] == 'user';
            return Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4), padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: isMe ? Colors.green : Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                child: Text(_msgs[i]['text']!, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 16)),
              ),
            );
          },
        )),
        if (_isLoading) const CircularProgressIndicator(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            Expanded(child: TextField(controller: _c, decoration: InputDecoration(hintText: "Type...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))))),
            IconButton(icon: const Icon(Icons.send, color: Colors.green, size: 30), onPressed: _send)
          ]),
        )
      ]),
    );
  }
}
