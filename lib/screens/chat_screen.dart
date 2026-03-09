import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/badge_system.dart';
import '../api/api_service.dart';

class ChatScreen extends StatefulWidget { const ChatScreen({super.key}); @override State<ChatScreen> createState() => _ChatScreenState(); }
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _c = TextEditingController();
  final List<Map<String, String>> _msgs = [{"role": "ai", "text": "Hi! I am Nova. Let's speak English, Hindi, or Bengali! Tap the mic to talk."}];
  bool _isLoading = false;
  bool _isListening = false;

  void _send() async {
    if (_c.text.isEmpty) return;
    String text = _c.text; _c.clear();
    setState(() { _msgs.add({"role": "user", "text": text}); _isLoading = true; });
    
    // Level Up Functionality! Add XP. Every 50 XP = 1 Level.
    context.read<GameManager>().addXP(20); 
    
    String reply = await ApiService.sendChatMessage(text);
    setState(() { _msgs.add({"role": "ai", "text": reply}); _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speak with Nova AI'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          IconButton(icon: const Icon(Icons.translate), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Multi-Language Enabled: English, Hindi, Bengali")));
          })
        ],
      ),
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
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20), topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isMe ? 20 : 0), bottomRight: Radius.circular(isMe ? 0 : 20),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!isMe) const Icon(Icons.volume_up, color: Colors.grey, size: 20),
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
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, -5))]),
          child: Row(children: [
            // Voice Mic Button
            GestureDetector(
              onTap: () => setState(() => _isListening = !_isListening),
              child: CircleAvatar(
                radius: 25, backgroundColor: _isListening ? Colors.red : Colors.grey.shade200,
                child: Icon(Icons.mic, color: _isListening ? Colors.white : Colors.grey.shade700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _c, decoration: InputDecoration(hintText: "Type or speak...", border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)), contentPadding: const EdgeInsets.symmetric(horizontal: 20)))),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 25, backgroundColor: Theme.of(context).colorScheme.primary,
              child: IconButton(icon: const Icon(Icons.send, color: Colors.white), onPressed: _send),
            )
          ]),
        )
      ]),
    );
  }
}
