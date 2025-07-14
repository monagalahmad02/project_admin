class SubscriptionSettingModel {
  final int id;
  final String subscriptionValue;
  final int subscriptionDurationDays;
  final String currency;
  final int trialDurationDays;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionSettingModel({
    required this.id,
    required this.subscriptionValue,
    required this.subscriptionDurationDays,
    required this.currency,
    required this.trialDurationDays,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionSettingModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionSettingModel(
      id: json['id'],
      subscriptionValue: json['subscription_value'],
      subscriptionDurationDays: json['subscription_duration_days'],
      currency: json['currency'],
      trialDurationDays: json['trial_duration_days'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subscription_value': subscriptionValue,
      'subscription_duration_days': subscriptionDurationDays,
      'currency': currency,
      'trial_duration_days': trialDurationDays,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
