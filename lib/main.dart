import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:project3admin/widght/auth_page/login_page.dart';
import 'package:project3admin/widght/dashboard_page/dashboard_page.dart';
import 'controller/home_controller/home_controller.dart';
import 'controller/side_bar_controller/side_bar_controller.dart';


const baseUrl = 'http://127.0.0.1:8000/api';
const baseUrl1 = 'http://127.0.0.1:8000/image';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(SidebarController());
  Get.put(HomeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final sidebarController = Get.put(SidebarController());

    bool isLoggedIn = box.read('isLoggedIn') == true;

    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home:  isLoggedIn ? DashboardPage() : LoginPage(),    //   isLoggedIn ? DashboardPage() :
      debugShowCheckedModeBanner: false,
    );
  }
}
