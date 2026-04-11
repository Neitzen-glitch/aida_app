// lib/features/deals/models/deal_models.dart

class Deal {
  final String id;
  final String userId;
  final String clientName;
  final String status; // 'Lead', 'Negotiation', 'Contract', 'Closed'
  final double value;

  Deal({
    required this.id,
    required this.userId,
    required this.clientName,
    required this.status,
    required this.value,
  });

  factory Deal.fromMap(Map<String, dynamic> map) {
    return Deal(
      id: map['id'],
      userId: map['user_id'],
      clientName: map['client_name'],
      status: map['status'] ?? 'Lead',
      value: (map['value'] ?? 0).toDouble(),
    );
  }
}

class Referral {
  final String id;
  final String userId;
  final String referredBusiness;
  final String whyRecommend;

  Referral({
    required this.id,
    required this.userId,
    required this.referredBusiness,
    required this.whyRecommend,
  });

  factory Referral.fromMap(Map<String, dynamic> map) {
    return Referral(
      id: map['id'],
      userId: map['user_id'],
      referredBusiness: map['referred_business'],
      whyRecommend: map['why_recommend'],
    );
  }
}