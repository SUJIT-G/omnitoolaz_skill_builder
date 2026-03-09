import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // We will paste your real Cloudflare URL here later!
  static const String workerUrl = 'https://YOUR_WORKER_URL_HERE.workers.dev';

  static Future<String> sendChatMessage(String message) async {
    try {
      final res = await http.post(Uri.parse('\$workerUrl/ai-chat'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': message}));
      if (res.statusCode == 200) return jsonDecode(res.body)['reply'];
    } catch (e) {} // Fallback if API fails
    await Future.delayed(const Duration(seconds: 1));
    return "The AI Backend is not connected yet! But you said: \$message";
  }

  static Future<List<Map<String, dynamic>>> getDailyQuiz() async {
    try {
      final res = await http.get(Uri.parse('\$workerUrl/quiz'));
      if (res.statusCode == 200) return List<Map<String, dynamic>>.from(jsonDecode(res.body));
    } catch (e) {} // Fallback
    return [
      {"q": "What is the synonym of 'Fast'?", "options": ["Slow", "Quick", "Lazy"], "answer": "Quick"},
      {"q": "Which is correct?", "options": ["He go to school", "He goes to school"], "answer": "He goes to school"},
      {"q": "Past tense of 'Run'?", "options": ["Ran", "Runned", "Running"], "answer": "Ran"}
    ];
  }
}
