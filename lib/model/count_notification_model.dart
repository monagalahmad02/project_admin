class CountNotificationModel {
  final int notifications;

  CountNotificationModel({required this.notifications});

  factory CountNotificationModel.fromJson(Map<String, dynamic> json) {
    return CountNotificationModel(
      notifications: json['notifications'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications,
    };
  }
}
