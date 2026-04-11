class BusinessSystem {
  final String id;
  final String userId;
  final String businessProfileId;
  final String systemType; // e.g., 'Retail', 'Service', 'SaaS/Software'
  final bool autopilotEnabled;
  final List<dynamic> tasks; // Stored as JSON in Supabase

  BusinessSystem({
    required this.id,
    required this.userId,
    required this.businessProfileId,
    required this.systemType,
    this.autopilotEnabled = false,
    this.tasks = const [],
  });

  factory BusinessSystem.fromMap(Map<String, dynamic> map) {
    return BusinessSystem(
      id: map['id'],
      userId: map['user_id'],
      businessProfileId: map['business_profile_id'],
      systemType: map['system_type'] ?? 'Custom',
      autopilotEnabled: map['autopilot_enabled'] ?? false,
      tasks: map['tasks'] ?? [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'business_profile_id': businessProfileId,
      'system_type': systemType,
      'autopilot_enabled': autopilotEnabled,
      'tasks': tasks,
    };
  }
}