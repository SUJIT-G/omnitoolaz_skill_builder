import 'package:flutter/material.dart';
import '../main_navigation.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.language, size: 80, color: Color(0xFF58CC02)),
              const SizedBox(height: 20),
              const Text("OmniToolaz", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF58CC02))),
              const Text("Learn English, Hindi, Bengali", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 50),
              TextField(decoration: InputDecoration(hintText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 16),
              TextField(obscureText: true, decoration: InputDecoration(hintText: "Password", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () {
                    // TODO: Replace with Firebase Auth logic once google-services.json is added
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
                  },
                  child: const Text("Log In / Sign Up", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(onPressed: (){}, child: const Text("Continue with Google", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }
}
