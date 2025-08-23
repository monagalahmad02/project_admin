class DashLoungeModel {
  final int requestsLast30;
  final int requestsChange;
  final int acceptedLast30;
  final int acceptedChange;
  final int activeTotal;
  final int activeChange;

  DashLoungeModel({
    required this.requestsLast30,
    required this.requestsChange,
    required this.acceptedLast30,
    required this.acceptedChange,
    required this.activeTotal,
    required this.activeChange,
  });

  /// من JSON → موديل
  factory DashLoungeModel.fromJson(Map<String, dynamic> json) {
    return DashLoungeModel(
      requestsLast30: json['requests_last_30'] ?? 0,
      requestsChange: json['requests_change'] ?? 0,
      acceptedLast30: json['accepted_last_30'] ?? 0,
      acceptedChange: json['accepted_change'] ?? 0,
      activeTotal: json['active_total'] ?? 0,
      activeChange: json['active_change'] ?? 0,
    );
  }

  /// من موديل → JSON (مفيد للتخزين أو الإرسال)
  Map<String, dynamic> toJson() {
    return {
      'requests_last_30': requestsLast30,
      'requests_change': requestsChange,
      'accepted_last_30': acceptedLast30,
      'accepted_change': acceptedChange,
      'active_total': activeTotal,
      'active_change': activeChange,
    };
  }
}
