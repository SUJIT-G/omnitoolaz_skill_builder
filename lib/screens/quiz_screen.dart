import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../models/badge_system.dart';

class QuizScreen extends StatefulWidget { const QuizScreen({super.key}); @override State<QuizScreen> createState() => _QuizScreenState(); }
class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _q = []; int _idx = 0; int _score = 0; bool _loading = true;

  @override void initState() { super.initState(); _load(); }
  void _load() async { _q = await ApiService.getDailyQuiz(); setState(() => _loading = false); }

  void _ans(String selected) {
    if (selected == _q[_idx]['answer']) _score += 10;
    if (_idx < _q.length - 1) setState(() => _idx++);
    else {
      context.read<GameManager>().addXP(_score);
      showDialog(context: context, builder: (_) => AlertDialog(title: Text("Score: $_score XP!"), actions: [TextButton(onPressed: ()=>Navigator.pop(context), child: Text("OK"))]));
    }
  }

  @override Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Quiz')),
      body: Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(_q[_idx]['q'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const Spacer(),
        ..._q[_idx]['options'].map((opt) => Padding(padding: const EdgeInsets.only(bottom: 16), child: ElevatedButton(
          style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20), backgroundColor: Colors.white, foregroundColor: Colors.black, side: BorderSide(color: Colors.grey.shade300)),
          onPressed: () => _ans(opt), child: Text(opt, style: const TextStyle(fontSize: 18)),
        ))).toList(),
        const Spacer(),
      ])),
    );
  }
}
