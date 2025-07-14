class Dashboard2Data {
  final int requestsLast30;
  final double requestsChange;
  final int acceptedLast30;
  final double acceptedChange;
  final int activeTotal;
  final double activeChange;

  Dashboard2Data({
    required this.requestsLast30,
    required this.requestsChange,
    required this.acceptedLast30,
    required this.acceptedChange,
    required this.activeTotal,
    required this.activeChange,
  });

  factory Dashboard2Data.fromJson(Map<String, dynamic> json) {
    return Dashboard2Data(
      requestsLast30: json['requests_last_30'] ?? 0,
      requestsChange: (json['requests_change'] ?? 0).toDouble(),
      acceptedLast30: json['accepted_last_30'] ?? 0,
      acceptedChange: (json['accepted_change'] ?? 0).toDouble(),
      activeTotal: json['active_total'] ?? 0,
      activeChange: (json['active_change'] ?? 0).toDouble(),
    );
  }
}
