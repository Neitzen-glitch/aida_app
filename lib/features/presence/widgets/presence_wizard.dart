import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';

class PresenceWizard extends StatefulWidget {
  final VoidCallback onComplete;
  const PresenceWizard({super.key, required this.onComplete});

  @override
  State<PresenceWizard> createState() => _PresenceWizardState();
}

class _PresenceWizardState extends State<PresenceWizard> {
  final PageController _pageController = PageController();

  int _currentStep = 0;

  // Form Controllers

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _audienceController = TextEditingController();

  // Simple SEO scoring logic
  int get _calcultedScore {
    int score = 0;

    if (_nameController.text.length > 3) score += 30;
    if (_descController.text.length  > 20) score += 40;
    if (_audienceController.text.isNotEmpty) score += 30;
    return score;
  }

  void _nextStep() {
    if (_currentStep < 3) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
      setState(() => _currentStep++);
    } else {
      _saveToSupabase();
    }
  }

  Future<void> _saveToSupabase() async {
    final user = supabase.auth.currentUser;
    await supabase.from('business_profiles').insert({
      'user_id': user!.id,
      'business_name': _nameController.text,
      'description': _descController.text,
      'target_audience': _audienceController.text,
      'seo_score': _calcultedScore,
      'brand_colors': 'Blue/Slate', //Default for MVP
    });
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setup Your Business Online Presence", style: TextStyle(fontSize: 16)),
        leading: _currentStep > 0 ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: () {
          _pageController.previousPage(duration: const Duration(microseconds: 300), curve: Curves.ease);
          setState(() => _currentStep--);
        }) : null,
    ),
    body: Column(
      children: [
        LinearProgressIndicator(value: (_currentStep + 1) / 4),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _stepTemplate("Business Identity", [

                _inputField("Business Name", _nameController),
                _inputField("What do you sell", _descController, maxLines: 3),
                ]),

              _stepTemplate("Target Audience", [

                _inputField("Who is your Ideal Customer?", _audienceController),
                const Text("\nTip: Be specific (e.g., 'Freelance designers in Lagos')"),
                ]),                

              _stepTemplate("SEO Preview", [
                
                Text("Calculated SEO Score: $_calcultedScore%", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),

                const SizedBox(height: 20),
                const Text("Based on your input, AIDA is generating meta-tags and keywords automatically."),
              ]),

              _stepTemplate("Finalize", [
                const Icon(Icons.auto_awesome, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
                const Text("Ready to take your business live?", textAlign: TextAlign.center),
                ]),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: Text(_currentStep == 3 ? "Launch Now" : "Next Step"),
          ),
        ),
      ],
    ),
    );
  }

  Widget _stepTemplate(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}