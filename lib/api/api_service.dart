import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Your real Cloudflare Worker URL!
  static const String workerUrl = 'https://omniskill-ai.devsujit.workers.dev';

  static Future<String> sendChatMessage(String message) async {
    try {
      final res = await http.post(Uri.parse('$workerUrl/ai-chat'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}));
      if (res.statusCode == 200) return jsonDecode(res.body)['reply'];
    } catch (e) {
      print("Chat API Error: $e");
    }
    return "AI is sleeping right now! But you said: $message";
  }

  static Future<List<Map<String, dynamic>>> getDailyQuiz() async {
    try {
      final res = await http.get(Uri.parse('$workerUrl/quiz'));
      if (res.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(res.body));
      }
    } catch (e) {
      print("Quiz API Error: $e");
    }
    // Backup Quiz if the internet fails
    return [
      {"q": "What is the synonym of 'Fast'?", "options": ["Slow", "Quick", "Lazy"], "answer": "Quick"},
      {"q": "Which is correct?", "options": ["He go to school", "He goes to school"], "answer": "He goes to school"},
      {"q": "Past tense of 'Run'?", "options": ["Ran", "Runned", "Running"], "answer": "Ran"}
    ];
  }
}
