import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main_navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isLoading = false;

  void _loginOrSignup() async {
    if (_email.text.isEmpty || _password.text.isEmpty) return;
    setState(() => _isLoading = true);
    
    try {
      // 1. Try to sign in
      await _auth.signInWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
      _goToHome();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        try {
          // 2. If user doesn't exist, create a new account!
          await _auth.createUserWithEmailAndPassword(email: _email.text.trim(), password: _password.text.trim());
          _goToHome();
        } catch (e) {
          _showError(e.toString());
        }
      } else {
        _showError(e.message ?? "Authentication Error");
      }
    }
    setState(() => _isLoading = false);
  }

  void _goToHome() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainNavigation()));
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

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
              const Text("Learn English from Hindi, Bengali, etc.", style: TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 50),
              
              TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: InputDecoration(hintText: "Email", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 16),
              TextField(controller: _password, obscureText: true, decoration: InputDecoration(hintText: "Password (Min 6 chars)", border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)))),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity, height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF58CC02), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: _isLoading ? null : _loginOrSignup,
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text("Log In / Create Account", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
