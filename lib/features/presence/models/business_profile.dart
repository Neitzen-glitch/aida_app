class BusinessProfile {
  final String id;
  final String userId;
  final String businessName;
  final String description;
  final String targetAudience;
  final String brandColors;
  final String? websiteUrl;
  final Map<String, dynamic> socialLinks;
  final int seoScore;

  BusinessProfile({
    required this.id,
    required this.userId,
    required this.businessName,
    required this.description,
    required this.targetAudience,
    required this.brandColors,
    this.websiteUrl,
    required this.socialLinks,
    this.seoScore = 0,
  });

  // Convert Supabase Map to Dart Object
  factory BusinessProfile.fromMap(Map<String, dynamic> map) {
    return BusinessProfile(
      id: map['id'], 
      userId: map['user_id'], 
      businessName: map['business_name'] ?? '', 
      description: map['description'] ?? '', 
      targetAudience: map['target_audience'] ?? '', 
      brandColors: map['brand_colors'] ?? '',
      websiteUrl: map['website_url'], 
      socialLinks: map['social_links'] ?? {},
      seoScore: map['seo_score'] ?? 0,
    );
  }

  // Convert Dart Object to Map for Supabase
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'business_name': businessName,
      'description': description,
      'target_audience': targetAudience,
      'brand_colors': brandColors,
      'website_url': websiteUrl,
      'social_links': socialLinks,
      'seo_score': seoScore,
    };
  }
}