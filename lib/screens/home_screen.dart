import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/badge_system.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final gameManager = context.watch<GameManager>();
    return Scaffold(
      appBar: AppBar(title: const Text('OmniToolaz'), actions: [Text("${gameManager.xp} XP", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.orange)), const SizedBox(width: 20)]),
      body: Center(child: Text('Level ${gameManager.level}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
    );
  }
}
