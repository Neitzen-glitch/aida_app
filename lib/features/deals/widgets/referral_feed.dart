import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';

class ReferralFeed extends StatefulWidget {
  const ReferralFeed({super.key});

  @override
  State<ReferralFeed> createState() => _ReferralFeedState();
}

class _ReferralFeedState extends State<ReferralFeed> {
  // Mock data for MVP display
  final List<Map<String, String>> _referrals = [
    {"business": "Lagos Tech Hub", "reason": "Great coworking space for startups."},
  ];

  void _addReferralDialog() {
    final businessController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Refer a Business"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: businessController,
              decoration: const InputDecoration(labelText: "Business Name"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: "Why recommend them?"),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              // Save to Supabase
              final user = supabase.auth.currentUser;
              await supabase.from('referrals').insert({
                'user_id': user!.id,
                'referred_business': businessController.text,
                'why_recommend': reasonController.text,
              });

              setState(() {
                _referrals.add({
                  "business": businessController.text,
                  "reason": reasonController.text,
                });
              });
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Submit"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _referrals.length,
        itemBuilder: (context, index) {
          final ref = _referrals[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.recommend, color: Colors.green),
              title: Text(ref['business']!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(ref['reason']!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReferralDialog,
        icon: const Icon(Icons.add),
        label: const Text("Refer a Business"),
      ),
    );
  }
}