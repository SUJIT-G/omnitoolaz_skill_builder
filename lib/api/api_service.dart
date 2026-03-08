class ApiService {
  static Future<String> sendChatMessage(String m) async { await Future.delayed(const Duration(seconds: 1)); return "Great job! Keep practicing."; }
  static Future<List<Map<String, dynamic>>> getDailyQuiz() async { await Future.delayed(const Duration(seconds: 1)); return [{"q": "Synonym of Fast?", "options": ["Slow", "Quick"], "answer": "Quick"}]; }
  static Future<List<Map<String, dynamic>>> getLeaderboard() async { return [{"name": "Alice", "score": 2450}, {"name": "You", "score": 1200}]; }
}
