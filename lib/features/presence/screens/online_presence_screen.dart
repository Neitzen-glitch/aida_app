import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';
import '../widgets/presence_wizard.dart';

class OnlinePresenceScreen extends StatefulWidget {
  const OnlinePresenceScreen({super.key});

  @override
  State<OnlinePresenceScreen> createState() => _OnlinePresenceScreenState();
}

class _OnlinePresenceScreenState extends State<OnlinePresenceScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _businessData;

  @override
  void initState() {
    super.initState();
    _checkExistingPresence();
  }

  // Check Supabase if this user has a busiess profile
  Future<void> _checkExistingPresence() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase 
    .from('business_profiles')
    . select()
    .eq('user_id', user.id)
    .maybeSingle();

    setState(() {
      _businessData = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    // If no data exists, start the wizard
    if (_businessData == null) {
      return PresenceWizard(onComplete: _checkExistingPresence);
    }

    // Otherwise, show the Presence Dashboard
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/AIDA.png', height: 20),
        centerTitle: true,
      ),

      body: RefreshIndicator(
        onRefresh: _checkExistingPresence,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Presence Dashboard", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildStatCard("SEO Score", "${_businessData! ['seo_score']}%", Icons.trending_up),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: Text(_businessData! ['business_name']),
                  subtitle: const Text("Website Live & Optimized"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                ),
              ),

              const SizedBox(height: 24),
              const Text("Quick Actions", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                children: [
                  _actionButton("Edit Site", Icons.edit),

                  const SizedBox(width: 10),

                  _actionButton("Ad Accounts", Icons.ads_click),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _actionButton(String label, IconData icon) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: () {}, 
        icon: Icon(icon),
        label: Text(label),
      ),
    ); 
  }
}