import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/home_controller/home_controller.dart';
import '../../controller/notification_controller/conut_notification_controller.dart';
import '../../controller/side_bar_controller/side_bar_controller.dart';
import '../../controller/user_controller/get_details_user_controller.dart';
import '../../main.dart';
import '../details_lounge/details_launge.dart';
import '../notification_page/notification_page.dart';
import '../payment/payment_page.dart';
import '../profile_owner_page/profile_owner_page.dart';
import '../side_widght/add_car_request_page.dart';
import '../side_widght/add_hall_request_page.dart';
import '../side_widght/dashboard1_page.dart';
import '../side_widght/dashboard2_page.dart';
import '../side_widght/hall_managment_page.dart';
import '../side_widght/offes_managment_page.dart';
import '../side_widght/setting_page.dart';
import '../side_widght/subscription_setting_page.dart';
import '../side_widght/users_page.dart';

class DashboardPage extends StatelessWidget {
  final SidebarController sidebarController = Get.put(SidebarController());
  final HomeController homeController = Get.put(HomeController());
  final User7Controller user7controller = Get.put(User7Controller());
  final CountNotificationController countController =
  Get.put(CountNotificationController()); // 🔹 ربط كونترولر العدّاد

  DashboardPage({super.key}) {
    user7controller.fetchUserDetails(1);
    countController.fetchCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          buildSidebar(context),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // حقل البحث
                      Container(
                        width: 700,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.language_outlined),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.dark_mode_outlined),
                            onPressed: () {},
                          ),

                          Obx(() {
                            final count = countController.count.value;
                            return Stack(
                              clipBehavior: Clip.none, // يخلي المسافة تظهر خارج حدود الستاك
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_none_outlined),
                                  onPressed: () async {
                                    await Get.to(() => const NotificationPage());
                                    // بعد الرجوع من صفحة الإشعارات حدث العدّاد
                                    countController.fetchCount();
                                  },
                                ),
                                if (count > 0)
                                  Positioned(
                                    right: 4,  // 🔹 غيرتها من 8 → 4 (بتبعدها شوي عن الأيقونة)
                                    top: -2,   // 🔹 سالبة عشان تطلع فوق الأيقونة مو ملزوقة
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 20,
                                        minHeight: 20,
                                      ),
                                      child: Text(
                                        '$count',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }),

                          const SizedBox(width: 20),

                          // 🧑 صورة واسم المستخدم
                          Obx(() {
                            if (user7controller.isLoading.value) {
                              return const SizedBox(
                                width: 80,
                                child: LinearProgressIndicator(minHeight: 2),
                              );
                            }

                            final user = user7controller.user.value;

                            return Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: (user?.photo != null &&
                                      user!.photo!.isNotEmpty)
                                      ? NetworkImage("${baseUrl1}/${user.photo}")
                                      : null,
                                  child: (user?.photo == null || user!.photo!.isEmpty)
                                      ? const Icon(Icons.person, color: Colors.white)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  user?.name ?? "Admin",
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }),
                          const SizedBox(width: 20),
                        ],
                      ),
                    ],
                  ),
                ),

                // المحتوى المتغير
                Expanded(
                  child: Obx(() {
                    if (homeController.selectedOwnerId.value != null) {
                      return ProfileOwnerPage(
                          userId: homeController.selectedOwnerId.value!);
                    } else if (homeController.selectedHallId.value != null) {
                      return HallDetailsWidget(
                          hallId: homeController.selectedHallId.value!);
                    } else {
                      return _buildContentForIndex(
                          sidebarController.selectedIndex.value);
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSidebar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      color: const Color(0xFFEBECF0),
      child: Column(
        children: [
          Container(
            height: 100,
            color: const Color(0xFF1976D2),
            alignment: Alignment.centerLeft,
            child:const Center(
              child: Text(
                "My Lounges",
                style: TextStyle(
                    fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSidebarTile(0, Icons.dashboard_customize_outlined, "Dashboard 1"),
                  _buildSidebarTile(1, Icons.dashboard_customize_outlined, "Dashboard 2"),
                  _buildSidebarTile(2, Icons.meeting_room_outlined, "Hall management"),
                  _buildSidebarTile(3, Icons.add, "Requests to add a hall"),
                  _buildSidebarTile(4, Icons.apartment_outlined, "Office management"),
                  _buildSidebarTile(5, Icons.car_rental_outlined, "Requests to add a car office"),
                  _buildSidebarTile(6, Icons.people_outline, "Application users"),
                  _buildSidebarTile(7, Icons.people_alt_outlined, "Subscription setting"),
                  _buildSidebarTile(8, Icons.block_outlined, "Blocked User"),
                  _buildSidebarTile(9, Icons.payment_outlined, "Payments List"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarTile(int index, IconData icon, String title) {
    return Obx(() {
      final isSelected = sidebarController.selectedIndex.value == index;
      return InkWell(
        onTap: () {
          sidebarController.selectedIndex.value = index;
          homeController.clearSelection();
        },
        child: Container(
          width: 300,
          color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
          child: ListTile(
            leading: Icon(icon, color: isSelected ? Colors.white : Colors.black),
            title: Text(
              title,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildContentForIndex(int index) {
    switch (index) {
      case 0:
        return Dashboard1Page();
      case 1:
        return Dashboard2Page();
      case 2:
        return HallManagementPage();
      case 3:
        return AddHallRequestsPage();
      case 4:
        return OfficeManagementPage();
      case 5:
        return AddCarOfficeRequestsPage();
      case 6:
        return UsersPage();
      case 7:
        return SubscriptionSettingPage();
      case 8:
        return SettingsPage();
      case 9:
        return PaymentsPage();
      default:
        return Dashboard1Page();
    }
  }
}
