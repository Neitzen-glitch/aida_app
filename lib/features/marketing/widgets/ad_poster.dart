import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';

class AdPoster extends StatefulWidget {
  final Map<String, dynamic> availablePlatforms;

  const AdPoster({super.key, required this.availablePlatforms});

  @override
  State<AdPoster> createState() => _AdPosterState();
}

class _AdPosterState extends State<AdPoster> {
  final List<String> _selectedPlatforms = [];
  bool _isPosting = false;

  Future<void> _shipCampaign() async {
    if (_selectedPlatforms.isEmpty) return;

    setState(() => _isPosting = true);

    // Mock API call to social platforms
    await Future.delayed(const Duration(seconds: 2));

    final user = supabase.auth.currentUser;
    await supabase.from('marketing_content').insert({
      'user_id': user!.id,
      'content_type': 'Ad Campaign',
      'text_body': 'Automated campaign deployment.',
      'target_platforms': _selectedPlatforms,
      'status': 'Published', // Setting as published to simulate a live launch
    });

    if (mounted) {
      setState(() => _isPosting = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Campaign successfully shipped by AIDA!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no social links were added in Feature 1, prompt the user
    if (widget.availablePlatforms.isEmpty) {
      return const Center(
        child: Text("No social accounts found. Please link them in the Presence tab first."),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Ship Campaign", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("AIDA will distribute your approved ad copy to selected platforms."),
          const SizedBox(height: 24),
          const Text("Select Destinations:", style: TextStyle(fontWeight: FontWeight.bold)),

          // Dynamically build checkboxes based on connected accounts from Feature 1
          ...widget.availablePlatforms.keys.map((platform) {
            return CheckboxListTile(
              title: Text(platform.toUpperCase()),
              value: _selectedPlatforms.contains(platform),
              onChanged: (bool? selected) {
                setState(() {
                  if (selected == true) {
                    _selectedPlatforms.add(platform);
                  } else {
                    _selectedPlatforms.remove(platform);
                  }
                });
              },
            );
          }),

          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isPosting || _selectedPlatforms.isEmpty ? null : _shipCampaign,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: _isPosting ? const Text("Shipping Campaign...") : const Text("Deploy Now"),
          )
        ],
      ),
    );
  }
}