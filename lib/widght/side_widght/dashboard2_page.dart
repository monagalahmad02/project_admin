import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboard_controller/dashboard2_controller.dart';

class Dashboard2Page extends StatelessWidget {
  Dashboard2Page({super.key});

  final Dashboard2Controller controller = Get.put(Dashboard2Controller());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final data = controller.dashboardData.value;

      if (data == null) {
        return const Center(child: Text("فشل في تحميل البيانات"));
      }

      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Welcome Ahmad!'),
                const SizedBox(height: 35),

                _buildSectionTitle('Lounges', isBold: false),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.meeting_room,
                        "Number of request to add hall",
                        data.requestsLast30,
                        data.requestsChange,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.verified,
                        "Number of accepted Halls",
                        data.acceptedLast30,
                        data.acceptedChange,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.local_activity,
                        "Number of currently Active Halls",
                        data.activeTotal,
                        data.activeChange,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('Car reservation Office', isBold: false),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.directions_car,
                        "Number of request to add an office",
                        30,
                        3, // نسبة ثابتة مثالًا
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.verified,
                        "Number of accepted Offices",
                        22,
                        0,
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.local_activity,
                        "Number of currently Active Offices",
                        18,
                        -2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSectionTitle(String title, {bool isBold = true}) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildStatCard(
      IconData icon,
      String label,
      int count,
      double percent, // القيمة جاهزة من الـ API
      ) {
    final bool isPositive = percent >= 0;
    final String percentChange = "${percent.toStringAsFixed(1)}%";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 32, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$count',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text("Last 30 days", style: TextStyle(color: Colors.grey)),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isPositive ? Colors.green : Colors.red,
                ),
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  percentChange,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
    );
  }
}
