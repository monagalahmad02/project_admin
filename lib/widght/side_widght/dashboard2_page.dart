import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/dashboard_controller/dash_office_controller.dart';
import '../../controller/dashboard_controller/dash_lounge_controller.dart';

class Dashboard2Page extends StatelessWidget {
  Dashboard2Page({super.key});

  final DashOfficeController officeController = Get.put(DashOfficeController());
  final DashLoungeController loungeController = Get.put(DashLoungeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (officeController.isLoading.value || loungeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (officeController.errorMessage.isNotEmpty) {
          return Center(child: Text(officeController.errorMessage.value));
        }
        if (loungeController.errorMessage.isNotEmpty) {
          return Center(child: Text(loungeController.errorMessage.value));
        }

        final officeData = officeController.dashOffice.value;
        final loungeData = loungeController.dashLounge.value;

        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Welcome Admin!'),
                const SizedBox(height: 35),

                // 🔹 Lounges
                _buildSectionTitle('Lounges', isBold: false),
                const SizedBox(height: 20),
                loungeData == null
                    ? const Center(child: Text("فشل في تحميل بيانات الصالات"))
                    : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.meeting_room,
                        "Number of request to add hall",
                        loungeData.requestsLast30,
                        loungeData.requestsChange.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.verified,
                        "Number of accepted Halls",
                        loungeData.acceptedLast30,
                        loungeData.acceptedChange.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.local_activity,
                        "Number of currently Active Halls",
                        loungeData.activeTotal,
                        loungeData.activeChange.toDouble(),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // 🔹 Car reservation Office
                _buildSectionTitle('Car reservation Office', isBold: false),
                const SizedBox(height: 20),
                officeData == null
                    ? const Center(child: Text("فشل في تحميل بيانات المكاتب"))
                    : Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        Icons.directions_car,
                        "Number of request to add an office",
                        officeData.requestsLast30,
                        officeData.requestsChange.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.verified,
                        "Number of accepted Offices",
                        officeData.acceptedLast30,
                        officeData.acceptedChange.toDouble(),
                      ),
                    ),
                    const SizedBox(width: 30),
                    Expanded(
                      child: _buildStatCard(
                        Icons.local_activity,
                        "Number of currently Active Offices",
                        officeData.activeTotal,
                        officeData.activeChange.toDouble(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
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
      double percent,
      ) {
    final bool isPositive = percent >= 0;
    final String percentChange = "${percent.toStringAsFixed(0)}%";

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
