import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';
import '../widgets/system_template_picker.dart';
import '../widgets/operations_organizer.dart';

class OperationsScreen extends StatefulWidget {
  const OperationsScreen({super.key});

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _businessProfile;
  Map<String, dynamic>? _businessSystem;

  @override
  void initState() {
    super.initState();
    _loadBusinessData();
  }

  // Feature 2 relies on Feature 1. We fetch the profile first.
  Future<void> _loadBusinessData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Get the business name and ID from Feature 1
      final profileResponse = await supabase
          .from('business_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (profileResponse != null) {
        _businessProfile = profileResponse;

        // 2. See if they already have an operations system set up
        final systemResponse = await supabase
            .from('business_systems')
            .select()
            .eq('business_profile_id', profileResponse['id'])
            .maybeSingle();

        _businessSystem = systemResponse;
      }
    } catch (e) {
      debugPrint("Error loading data: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Guard: Owner must complete Feature 1 first
    if (_businessProfile == null) {
      return Scaffold(
        appBar: AppBar(title: Image.asset('assets/images/AIDA.png', height: 20), centerTitle: true),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Please complete your Online Presence (Tab 1) before setting up Operations.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      );
    }

    // The Main Operations Hub with 4 Tabs
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/AIDA.png', height: 20),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "System Setup"),
              Tab(text: "Organizer"),
              Tab(text: "Coordination"),
              Tab(text: "Autopilot"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Sub-feature 1: System Development
            SystemTemplatePicker(
                profileId: _businessProfile!['id'],
                currentSystemType: _businessSystem?['system_type']
            ),
            // Sub-feature 2: Operations Organizer
            OperationsOrganizer(
              systemId: _businessSystem?['id'],
            ),
            // Sub-feature 3: Coordination (Placeholder for Calendar MVP)
            const Center(child: Text("Coordination Timeline Coming Soon...")),
            // Sub-feature 4: Autopilot
            _buildAutopilotTab(),
          ],
        ),
      ),
    );
  }

  // MVP UI for Sub-feature 4
  Widget _buildAutopilotTab() {
    bool isAutopilot = _businessSystem?['autopilot_enabled'] ?? false;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("AIDA Autopilot", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Switch(
                value: isAutopilot,
                onChanged: (val) {
                  // TODO: Update Supabase boolean
                  setState(() {
                    _businessSystem?['autopilot_enabled'] = val;
                  });
                },
              )
            ],
          ),
          const SizedBox(height: 10),
          const Text("When active, AIDA will autonomously coordinate your daily routines."),
          const Divider(height: 40),
          const Text("Automated Suggestions:", style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(value: true, onChanged: (v){}, title: const Text("Daily profit check & report")),
          CheckboxListTile(value: true, onChanged: (v){}, title: const Text("Staff attendance reminder")),
          CheckboxListTile(value: false, onChanged: (v){}, title: const Text("Auto-generate weekly summary")),
        ],
      ),
    );
  }
}