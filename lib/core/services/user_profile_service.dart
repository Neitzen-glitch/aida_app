import 'package:flutter/material.dart';
import '../supabase/supabase_client.dart';

class UserProfileService extends ChangeNotifier {
  Map<String, dynamic>? _profile;
  Map<String, dynamic>? _businessSystem;
  bool _isLoading = true;

  Map<String, dynamic>? get profile => _profile;
  Map<String, dynamic>? get businessSystem => _businessSystem;
  bool get isLoading => _isLoading;

  // Trial Logic Getters
  DateTime? get trialStart => _profile?['trial_start_date'] != null
      ? DateTime.parse(_profile!['trial_start_date'])
      : null;

  int get daysUsed {
    if (trialStart == null) return 0;
    return DateTime.now().difference(trialStart!).inDays;
  }

  bool get isExpired => daysUsed > 97; // 90 days + 7 days grace
  bool get isInGracePeriod => daysUsed > 90 && daysUsed <= 97;

  // Initialize and fetch all global data
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // 1. Fetch Profile (Feature 1 + Trial Data)
      final profileData = await supabase
          .from('profiles')
          .select('*, business_profiles(*)')
          .eq('id', user.id)
          .maybeSingle();

      if (profileData == null) {
        debugPrint("No profile found for user: ${user.id}");
        return;
      }

      _profile = profileData;

      // 2. Fetch Operations System (Feature 2)
      final businessProfiles = profileData['business_profiles'];
      if (businessProfiles != null && businessProfiles is List && businessProfiles.isNotEmpty) {
        final systemData = await supabase
            .from('business_systems')
            .select()
            .eq('business_profile_id', businessProfiles[0]['id'])
            .maybeSingle();
        _businessSystem = systemData;
      } else if (businessProfiles != null && businessProfiles is Map) {
        final systemData = await supabase
            .from('business_systems')
            .select()
            .eq('business_profile_id', businessProfiles['id'])
            .maybeSingle();
        _businessSystem = systemData;
      }
    } catch (e) {
      debugPrint("Global Service Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Helper for Feature 3 & 4 to get business context
  String get businessName => _profile?['business_profiles']?['business_name'] ?? "My Business";
  Map<String, dynamic> get socialLinks => _profile?['business_profiles']?['social_links'] ?? {};
}