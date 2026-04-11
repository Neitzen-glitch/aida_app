import 'package:aida_app/features/auth/screens/login_screen.dart';
import 'package:aida_app/features/auth/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Image.asset('assets/icons/logo.png', height: 24),
        actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await AuthService().signOut();

            // Navigate back to login screen on sign out
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            }
          },
        )
      ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Welcome to AIDA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const Text("Your Perfect Business Assistant That Works With You", style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 30),
            _buildFeatureCard(
              "Operations",
              "Autopilot is made active. System is shipping tasks.",

              Icons.bolt,
              Colors.orange,
              "Autonomous"
            ),

            _buildFeatureCard(
              "Deals",
              "3 new leads require your input to close.",

              Icons.priority_high,
              Colors.blue,
              "Action Required"
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(String title, String subtitle, IconData icon, Color color, String status) {

  return Card(
    margin: const EdgeInsets.only(bottom: 16),
    child: ListTile(
      leading: CircleAvatar(backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
        child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    ),
  );
}
}

