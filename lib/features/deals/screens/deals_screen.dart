import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';
import '../widgets/referral_feed.dart';
import '../widgets/outreach_tracker.dart';
import '../widgets/deal_pipeline.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  bool _isLoading = true;
  String _businessName = "Loading...";
  String _systemType = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchBusinessContext();
  }

  // Pull context from Feature 1 and Feature 2
  Future<void> _fetchBusinessContext() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Get Business Profile (Feature 1)
      final profile = await supabase
          .from('business_profiles')
          .select('id, business_name')
          .eq('user_id', user.id)
          .maybeSingle();

      if (profile != null) {
        _businessName = profile['business_name'];

        // Get Business System (Feature 2) using the profile ID
        final system = await supabase
            .from('business_systems')
            .select('system_type')
            .eq('business_profile_id', profile['id'])
            .maybeSingle();

        if (system != null) {
          _systemType = system['system_type'];
        } else {
          _systemType = "No System Set";
        }
      } else {
        _businessName = "No Profile Found";
      }
    } catch (e) {
      debugPrint("Error fetching context: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset('assets/images/AIDA.png', height: 20),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Referrals"),
              Tab(text: "Outreach"),
              Tab(text: "Deal Pipeline"),
            ],
          ),
        ),
        body: Column(
          children: [
            // Context Header showing integration with F1 and F2
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Text(
                "Operating as: $_businessName | Framework: $_systemType",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            // The Tabs
            const Expanded(
              child: TabBarView(
                children: [
                  ReferralFeed(),
                  OutreachTracker(),
                  DealPipeline(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}