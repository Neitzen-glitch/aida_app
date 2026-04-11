import 'package:flutter/material.dart';
import '../../../core/supabase/supabase_client.dart';
import '../widgets/content_generator.dart';
import '../widgets/ad_poster.dart';


class MarketingScreen extends StatefulWidget {
  const MarketingScreen({super.key});

  @override
  State<MarketingScreen> createState() => _MarketingScreenState();
}

class _MarketingScreenState extends State<MarketingScreen> {
  bool _isLoading = true;
  Map<String, dynamic>? _socialLinks;

  @override
  void initState() {
    super.initState();
    _fetchSocialAccounts();
  }

  // Pulls the social accounts configured in Feature 1
  Future<void> _fetchSocialAccounts() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final response = await supabase
          .from('business_profiles')
          .select('social_links')
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null && response['social_links'] != null) {
        setState(() {
          _socialLinks = response['social_links'] as Map<String, dynamic>;
        });
      }
    } catch (e) {
      debugPrint("Error fetching social accounts: $e");
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
            tabs: [
              Tab(text: "Content AI"),
              Tab(text: "Ad Poster"),
              Tab(text: "Studio"),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                // Sub-feature 1: Agentic Content Creation
                const ContentGenerator(),
                // Sub-feature 3: Autonomous Ad Publisher
                AdPoster(availablePlatforms: _socialLinks ?? {}),
                // Sub-features 2 & 5: Photo/Video MVP Placeholder
                _buildStudioTab(),
              ],
            ),
            // Sub-feature 4: Learn as you go overlay
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: _buildLearnAsYouGoTip(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnAsYouGoTip() {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: const Padding(
        padding: EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(Icons.lightbulb, color: Colors.amber),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                "AIDA Tip: Consistent posting across 2+ platforms increases inbound leads by 40%. Let the system generate today's post.",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudioTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("AIDA Studio", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Upload media or generate AI images for your campaigns. (Coming Soon)", textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}