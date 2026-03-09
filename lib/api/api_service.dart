import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String workerUrl = 'https://omniskill-ai.devsujit.workers.dev';

  static Future<String> sendChatMessage(String message, String nativeLang) async {
    // We add secret instructions to tell the AI how to behave!
    String aiPrompt = "You are OmniToolaz, an English tutor. The user speaks $nativeLang. Teach them English. If they make a mistake, explain it in $nativeLang. Keep it short and friendly. User says: $message";
    
    try {
      final res = await http.post(Uri.parse('$workerUrl/ai-chat'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': aiPrompt}));
      if (res.statusCode == 200) return jsonDecode(res.body)['reply'];
    } catch (e) { print("Error: $e"); }
    
    if (nativeLang == "Hindi") return "माफ़ करना, मेरा सर्वर अभी सो रहा है! (Server sleeping)";
    if (nativeLang == "Bengali") return "দুঃখিত, আমার সার্ভার এখন ঘুমাচ্ছে! (Server sleeping)";
    return "Sorry, my AI brain is sleeping right now!";
  }

  static Future<List<Map<String, dynamic>>> getDailyQuiz() async {
    return [
      {"q": "What is the synonym of 'Fast'?", "options": ["Slow", "Quick", "Lazy"], "answer": "Quick"}
    ];
  }
}
