import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/services/ai_brain_service.dart'; // Import the service we created

class ContentGenerator extends StatefulWidget {
  const ContentGenerator({super.key});

  @override
  State<ContentGenerator> createState() => _ContentGeneratorState();
}

class _ContentGeneratorState extends State<ContentGenerator> {
  final TextEditingController _contentController = TextEditingController();
  final AiBrainService _aiService = AiBrainService();
  bool _isGenerating = false;
  String _selectedPlatform = "LinkedIn";

  Future<void> _handleGenerate() async {
    final profile = Provider.of<UserProfileService>(context, listen: false);
    
    setState(() => _isGenerating = true);

    try {
      final result = await _aiService.requestMarketingPost(
        businessId: profile.profile!['id'],
        name: profile.businessName,
        niche: "Business Technology", // You can pull this from profile too
        platform: _selectedPlatform,
      );

      if (result != null) {
        setState(() {
          _contentController.text = result;
        });
      }
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Draft your next post", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          
          // Platform Selector
          DropdownButton<String>(
            value: _selectedPlatform,
            items: ["LinkedIn", "Instagram", "Twitter", "Facebook"]
                .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                .toList(),
            onChanged: (val) => setState(() => _selectedPlatform = val!),
          ),

          const SizedBox(height: 12),
          
          // The Text Area
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: "AI will write here, or you can start typing...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white10 : Colors.grey[100],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // The AI MAGIC BUTTON
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: _isGenerating 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.auto_awesome),
              label: Text(_isGenerating ? "AIDA is thinking..." : "GENERATE WITH AI"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0052CC), // Neitzen Blue
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isGenerating ? null : _handleGenerate,
            ),
          ),
          const SizedBox(height: 80), // Space for the floating Tip overlay
        ],
      ),
    );
  }
}