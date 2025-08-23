import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controller/dashboard_controller/dashboard1_controller.dart';
import '../../model/dashboard1_model.dart';

class Dashboard1Page extends StatelessWidget {
  final Dashboard1Controller controller = Get.put(Dashboard1Controller());

  Dashboard1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        }

        final DashboardData? data = controller.dashboardData.value;
        if (data == null) {
          return const Center(child: Text("❌ لا توجد بيانات للعرض"));
        }

        // ترتيب المفاتيح وتحويلها لقائمة القيم
        List<String> sortedKeys = data.bookingsByMonth.keys.toList()..sort();
        List<double> bookingsList = sortedKeys
            .map((key) => data.bookingsByMonth[key]!.toDouble())
            .toList();

        return SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Welcome Ahmad!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // بطاقة المستخدم والإيرادات
              Row(
                children: [
                  _statCard(
                    icon: Icons.people,
                    count: data.userCount,
                    label: 'Number of people',
                    percentage: data.bookingsChangePct.toDouble(),
                  ),
                  const SizedBox(width: 16),
                  _statCard(
                    icon: Icons.money,
                    count: data.currentRevenue,
                    label: 'Monthly revenues',
                    percentage: data.revenueChangePct.toDouble(),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // عنوان مخطط الحجوزات
              const Text(
                "Number of bookings per month",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _barChart(bookingsList, sortedKeys)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        _infoCard(
                          title: "Average monthly bookings",
                          value:
                          "${data.averageMonthlyBookings} reservation per month",
                        ),
                        const SizedBox(height: 16),

                        _infoCard(
                          title: "The highest month in terms of bookings",
                          value: data.topMonth != null && data.topMonth!.isNotEmpty
                              ? "${data.topMonth} ${data.topMonthBookings} reservation"
                              : "${data.topMonthBookings} reservation",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _statCard({
    required IconData icon,
    required int count,
    required double percentage,
    required String label,
  }) {
    final bool isPositive = percentage >= 0;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 32, color: Colors.blue),
                const SizedBox(width: 12),
                Text(label,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text("$count",
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text("compared to last month"),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: isPositive ? Colors.green : Colors.red),
                  padding: const EdgeInsets.all(4.0),
                  child: Text("${percentage.abs().toStringAsFixed(1)}%",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500)),
                ),
                const SizedBox(width: 4),
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? Colors.green : Colors.red,
                  size: 30,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade800)),
        ],
      ),
    );
  }

  Widget _barChart(List<double> bookings, List<String> labels) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: bookings.isNotEmpty
              ? bookings.reduce((a, b) => a > b ? a : b) + 5
              : 10,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              axisNameWidget: const Text(
                "Months",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              axisNameSize: 30,
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  int index = value.toInt();
                  if (index >= 0 && index < labels.length) {
                    return Text(
                      labels[index].split('-')[1], // الشهر فقط
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const Text('');
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              axisNameWidget: const Text(
                "Number of Bookings",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              axisNameSize: 30,
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, _) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            topTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
            const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(
            bookings.length,
                (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: bookings[index],
                  color: Colors.blue,
                  width: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
