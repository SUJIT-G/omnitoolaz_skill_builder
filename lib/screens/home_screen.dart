import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/badge_system.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameManager = context.watch<GameManager>();
    
    // Supernova Style Learning Path
    final lessons = [
      {"level": 1, "title": "Basics & Greetings", "align": Alignment.center},
      {"level": 2, "title": "Past Continuous Tense!", "align": Alignment.centerLeft},
      {"level": 3, "title": "What Was I Doing?", "align": Alignment.center},
      {"level": 4, "title": "Future Goals in Hindi", "align": Alignment.centerRight},
      {"level": 5, "title": "Bengali Expressions", "align": Alignment.center},
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            const Icon(Icons.star, color: Colors.orange),
            const SizedBox(width: 8),
            Text("Level ${gameManager.level}", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.local_fire_department, color: Colors.orange),
            Text(" ${gameManager.xp} XP", style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          final lessonLevel = lesson["level"] as int;
          final isUnlocked = gameManager.level >= lessonLevel;
          final isCurrent = gameManager.level == lessonLevel;

          return Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: Align(
              alignment: lesson["align"] as Alignment,
              child: GestureDetector(
                onTap: isUnlocked ? () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatScreen()));
                } : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar / Node Bubble
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isUnlocked ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                        border: isCurrent ? Border.all(color: Colors.orange, width: 4) : null,
                        boxShadow: isUnlocked ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.4), blurRadius: 15, spreadRadius: 5)] : [],
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundColor: isUnlocked ? Colors.white : Colors.grey.shade400,
                        child: Icon(
                          isUnlocked ? Icons.star_rounded : Icons.lock_rounded,
                          color: isUnlocked ? Theme.of(context).colorScheme.primary : Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Title Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isUnlocked ? Colors.white : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                      ),
                      child: Text(
                        lesson["title"] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isUnlocked ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
