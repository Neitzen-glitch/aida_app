class MarketingContent {
  final String id;
  final String userId;
  final String contentType; // e.g., 'Social Post', 'Ad', 'Video Caption'
  final String textBody;
  final String? imageUrl;
  final List<String> targetPlatforms; // e.g., ['facebook', 'linkedin']
  final String status; // e.g., 'Draft', 'Published'

  MarketingContent({
    required this.id,
    required this.userId,
    required this.contentType,
    required this.textBody,
    this.imageUrl,
    required this.targetPlatforms,
    this.status = 'Draft',
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'content_type': contentType,
      'text_body': textBody,
      'image_url': imageUrl,
      'target_platforms': targetPlatforms,
      'status': status,
    };
  }
}