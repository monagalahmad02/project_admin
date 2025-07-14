// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../controller/home_controller/home_controller.dart';
// import '../../controller/side_bar_controller/side_bar_controller.dart';
// import '../details_lounge/details_launge.dart';
// import '../side_widght/add_car_request_page.dart';
// import '../side_widght/add_hall_request_page.dart';
// import '../side_widght/dashboard1_page.dart';
// import '../side_widght/dashboard2_page.dart';
// import '../side_widght/hall_managment_page.dart';
// import '../side_widght/offes_managment_page.dart';
// import '../side_widght/setting_page.dart';
// import '../side_widght/subscription_setting_page.dart';
// import '../side_widght/users_page.dart';
//
// class MainLayout extends StatelessWidget {
//   final Widget? child;
//
//   MainLayout({Key? key, this.child}) : super(key: key);
//
//   final homeController = Get.find<HomeController>();
//   final sidebarController = Get.find<SidebarController>(); // ممكن تستخدمه لاحقاً إن أردت
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           _buildSidebar(),
//           Expanded(
//             child: Column(
//               children: [
//                 _buildTopBar(),
//                 Expanded(
//                   child: child ?? Obx(() {
//                     if (homeController.selectedHallId.value != null) {
//                       return HallDetailsWidget(hallId: homeController.selectedHallId.value!);
//                     } else {
//                       return _buildContentForIndex(homeController.selectedPageIndex.value);
//                     }
//                   }),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildTopBar() {
//     return Container(
//       height: 70,
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // حقل البحث
//           SizedBox(
//             width: 400,
//             child: TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(30),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//           ),
//           Row(
//             children: const [
//               Icon(Icons.language_outlined),
//               SizedBox(width: 10),
//               Icon(Icons.dark_mode_outlined),
//               SizedBox(width: 10),
//               Icon(Icons.notifications_none_outlined),
//               SizedBox(width: 20),
//               Text("Ahmad Omar\nAdmin", textAlign: TextAlign.right),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebar() {
//     return Container(
//       width: 250,
//       color: const Color(0xFFEBECF0),
//       child: Column(
//         children: [
//           Container(
//             height: 100,
//             color: const Color(0xFF1976D2),
//             alignment: Alignment.centerLeft,
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: const Text(
//               "My Lounges",
//               style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//           ),
//           const SizedBox(height: 20),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildSidebarTile(0, Icons.dashboard, "Dashboard 1"),
//                   _buildSidebarTile(1, Icons.dashboard_customize, "Dashboard 2"),
//                   _buildSidebarTile(2, Icons.meeting_room, "Hall management"),
//                   _buildSidebarTile(3, Icons.add, "Requests to add a hall"),
//                   _buildSidebarTile(4, Icons.apartment, "Office management"),
//                   _buildSidebarTile(5, Icons.car_rental, "Requests to add a car office"),
//                   _buildSidebarTile(6, Icons.people, "Application users"),
//                   _buildSidebarTile(7, Icons.people, "Subscription setting"),
//                   _buildSidebarTile(8, Icons.settings, "Settings"),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSidebarTile(int index, IconData icon, String title) {
//     return Obx(() {
//       final isSelected = homeController.selectedPageIndex.value == index;
//       return InkWell(
//         onTap: () {
//           print('Selected Index: $index'); // متابعة الضغط
//           homeController.selectPage(index);
//         },
//         child: Container(
//           width: 220,
//           color: isSelected ? const Color(0xFF1976D2) : Colors.transparent,
//           child: ListTile(
//             leading: Icon(icon, color: isSelected ? Colors.white : Colors.black),
//             title: Text(
//               title,
//               style: TextStyle(color: isSelected ? Colors.white : Colors.black),
//             ),
//           ),
//         ),
//       );
//     });
//   }
//
//   Widget _buildContentForIndex(int index) {
//     switch (index) {
//       case 0:
//         return Dashboard1Page();
//       case 1:
//         return Dashboard2Page();
//       case 2:
//         return HallManagementPage();
//       case 3:
//         return AddHallRequestsPage();
//       case 4:
//         return OfficeManagementPage();
//       case 5:
//         return AddCarOfficeRequestsPage();
//       case 6:
//         return UsersPage();
//       case 7:
//         return SubscriptionSettingPage();
//       case 8:
//         return SettingsPage();
//       default:
//         return Dashboard1Page();
//     }
//   }
// }
