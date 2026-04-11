import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_profile_service.dart';

class TrialBanner extends StatelessWidget {
  const TrialBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<UserProfileService>(context);
    if (service.isLoading || service.trialStart == null) return const SizedBox.shrink();

    int daysLeft = 90 - service.daysUsed;
    int graceLeft = 97 - service.daysUsed;

    // Determine colors and message
    Color bgColor = Colors.blueGrey;
    String message = "$daysLeft days left in your free trial";

    if (service.isExpired) {
      bgColor = Colors.red;
      message = "Trial Expired. Please upgrade to continue.";
    } else if (service.isInGracePeriod) {
      bgColor = Colors.orange;
      message = "Grace Period: $graceLeft days left to upgrade.";
    }

    return Container(
      width: double.infinity,
      color: bgColor,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(message, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          if (!service.isExpired)
            TextButton(
              onPressed: () => _showPricing(context),
              child: const Text("UPGRADE", style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
            ),
        ],
      ),
    );
  }

  void _showPricing(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose your Neitzen Plan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _pricingTile("Starter", "\$50/mo", "Small businesses"),
            _pricingTile("Growth", "\$100/mo", "Scaling teams"),
            _pricingTile("Enterprise", "\$250/mo", "Full automation"),
            const SizedBox(height: 20),
            const Text("Payment coming soon (Stripe/Paystack integration)", style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _pricingTile(String title, String price, String sub) {
    return ListTile(
      title: Text(title),
      trailing: Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(sub),
      onTap: () {}, // Future: Link to payment
    );
  }
}