class DashboardData {
  final int userCount;
  final int currentBookings;
  final double bookingsChangePct;
  final int currentRevenue;
  final double revenueChangePct;
  final List<double> bookingsByMonth;
  final double averageMonthlyBookings;
  final String? topMonth;
  final int topMonthBookings;

  DashboardData({
    required this.userCount,
    required this.currentBookings,
    required this.bookingsChangePct,
    required this.currentRevenue,
    required this.revenueChangePct,
    required this.bookingsByMonth,
    required this.averageMonthlyBookings,
    required this.topMonth,
    required this.topMonthBookings,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    return DashboardData(
      userCount: json['user_count'] ?? 0,
      currentBookings: json['current_bookings'] ?? 0,
      bookingsChangePct:
      (json['bookings_change_pct'] ?? 0).toDouble(),
      currentRevenue: json['current_revenue'] ?? 0,
      revenueChangePct:
      (json['revenue_change_pct'] ?? 0).toDouble(),
      bookingsByMonth: (json['bookings_by_month'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
          [],
      averageMonthlyBookings:
      (json['average_monthly_bookings'] ?? 0).toDouble(),
      topMonth: json['top_month'],
      topMonthBookings: json['top_month_bookings'] ?? 0,
    );
  }
}
