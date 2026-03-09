import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _startPayment(BuildContext context) {
    // TODO: Replace with real Razorpay initialization once API Key is generated
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Razorpay Simulation"),
        content: const Text("Once you add your Razorpay API Key, this will open the real payment gateway for ₹99/month!"),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK"))],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium Plan'), backgroundColor: Colors.white, foregroundColor: Colors.black, elevation: 1),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, size: 100, color: Colors.orange),
            const SizedBox(height: 20),
            const Text("OmniToolaz Premium", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Unlock Supernova AI Voice, Unlimited Lessons, and Multi-Language Tutors.", textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.orange, width: 2)),
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text("1 Month Subscription", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text("₹99.00", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.orange)),
                    SizedBox(height: 10),
                    Text("Auto-renews monthly. Cancel anytime.", style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity, height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => _startPayment(context),
                child: const Text("Pay with Razorpay", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
