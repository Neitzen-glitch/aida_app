import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';

class SystemTemplatePicker extends StatefulWidget {
  final String profileId;
  final String? currentSystemType;

  const SystemTemplatePicker({super.key, required this.profileId, this.currentSystemType});

  @override
  State<SystemTemplatePicker> createState() => _SystemTemplatePickerState();
}

class _SystemTemplatePickerState extends State<SystemTemplatePicker> {
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.currentSystemType;
  }

  Future<void> _saveSystem() async {
    if (_selectedType == null) return;

    final user = supabase.auth.currentUser;

    // Upsert means it will insert if new, or update if it exists
    await supabase.from('business_systems').upsert({
      'user_id': user!.id,
      'business_profile_id': widget.profileId,
      'system_type': _selectedType,
      'updated_at': DateTime.now().toIso8601String(),
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Operations system updated successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tell us about your current operations...",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text("AIDA will structure your workflow based on your core business model."),
          const SizedBox(height: 24),

          _templateCard("Retail / E-commerce", Icons.storefront, "Inventory, orders, and customer management."),
          _templateCard("Service Agency", Icons.handshake, "Client onboarding, scheduling, and invoicing."),
          _templateCard("SaaS & Software", Icons.code, "Product roadmap, user support, and deployment cycles."),

          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _selectedType != null ? _saveSystem : null,
            style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            child: const Text("Initialize System"),
          )
        ],
      ),
    );
  }

  Widget _templateCard(String title, IconData icon, String description) {
    final isSelected = _selectedType == title;
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => setState(() => _selectedType = title),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}