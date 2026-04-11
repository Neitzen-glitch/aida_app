import 'package:flutter/material.dart';

class OutreachTracker extends StatelessWidget {
  const OutreachTracker({super.key});

  void _openOutreachDialog(BuildContext context, String clientName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Outreach: $clientName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("AIDA suggests this template:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.withOpacity(0.1),
              child: Text("Hi $clientName,\n\nWe noticed your recent growth and believe our services can help you scale even faster. Are you open to a quick chat?"),
            ),
            const SizedBox(height: 20),
            const Text("Owner Action Required:", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            const TextField(
              decoration: InputDecoration(
                hintText: "Add a personal touch...",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              // MVP: Just close the dialog. Later, integrate email/social API.
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Message queued for delivery!")));
            },
            child: const Text("Approve & Send"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Hot Leads (Action Needed)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        _buildLeadCard(context, "Alpha Tech Solutions", "Found via LinkedIn"),
        _buildLeadCard(context, "Zenith Retail", "Website Inquiry"),
      ],
    );
  }

  Widget _buildLeadCard(BuildContext context, String name, String source) {
    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Source: $source"),
        trailing: ElevatedButton(
          onPressed: () => _openOutreachDialog(context, name),
          child: const Text("Draft Message"),
        ),
      ),
    );
  }
}