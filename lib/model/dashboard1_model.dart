class DashboardData {
  final int userCount;
  final int currentBookings;
  final int bookingsChangePct;
  final int currentRevenue;
  final int revenueChangePct;
  final Map<String, int> bookingsByMonth;
  final int averageMonthlyBookings;
  final String? topMonth; // صار nullable
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
    Map<String, int> bookingsMap = {};

    // إذا جاي Map يتعامل معها، إذا جاي List فخليها فاضية
    if (json['bookings_by_month'] is Map) {
      (json['bookings_by_month'] as Map).forEach((key, value) {
        bookingsMap[key.toString()] = value ?? 0;
      });
    }

    return DashboardData(
      userCount: json['user_count'] ?? 0,
      currentBookings: json['current_bookings'] ?? 0,
      bookingsChangePct: json['bookings_change_pct'] ?? 0,
      currentRevenue: json['current_revenue'] ?? 0,
      revenueChangePct: json['revenue_change_pct'] ?? 0,
      bookingsByMonth: bookingsMap,
      averageMonthlyBookings: json['average_monthly_bookings'] ?? 0,
      topMonth: json['top_month'], // ممكن null
      topMonthBookings: json['top_month_bookings'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_count': userCount,
      'current_bookings': currentBookings,
      'bookings_change_pct': bookingsChangePct,
      'current_revenue': currentRevenue,
      'revenue_change_pct': revenueChangePct,
      'bookings_by_month': bookingsByMonth,
      'average_monthly_bookings': averageMonthlyBookings,
      'top_month': topMonth,
      'top_month_bookings': topMonthBookings,
    };
  }
}
