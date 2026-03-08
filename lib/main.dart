import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/badge_system.dart';
import 'main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => GameManager(prefs))],
      child: const OmniToolazApp(),
    ),
  );
}

class OmniToolazApp extends StatelessWidget {
  const OmniToolazApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniToolaz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF58CC02), primary: const Color(0xFF58CC02), tertiary: const Color(0xFFFFC800)),
      ),
      home: const MainNavigation(),
    );
  }
}
