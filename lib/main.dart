import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:project3admin/widght/auth_page/animation_page.dart';
import 'package:project3admin/widght/dashboard_page/dashboard_page.dart';
import 'controller/home_controller/home_controller.dart';
import 'controller/notification_controller/get_notification_controller.dart';
import 'controller/side_bar_controller/side_bar_controller.dart';
import 'controller/notification_controller/save_fcm_token_controller.dart';

const baseUrl = 'http://127.0.0.1:8000/api';
const baseUrl1 = 'http://127.0.0.1:8000/image';

// 🟢 Background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 إشعار Background وصل: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB-dPsQE2hm-FHHbOjgertF6ugyfQJ__1g",
      authDomain: "admainnotification.firebaseapp.com",
      projectId: "admainnotification",
      storageBucket: "admainnotification.firebasestorage.app",
      messagingSenderId: "12204011046",
      appId: "1:12204011046:web:7ffb09d506daf8ab5fc0e7",
      measurementId: "G-17TLCWF47T",
    ),
  );

  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Get.put(SidebarController());
  Get.put(HomeController());
  final notifController = Get.put(NotificationController(), permanent: true);
  notifController.fetchNotifications();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _initFCM();
    _setupNotificationListeners();
  }

  /// 🔹 طلب الإذن + حفظ/تحديث FCM Token
  Future<void> _initFCM() async {
    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Authorization status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("🔔 إذن الإشعارات معطى");

      // أول مرة يجيب التوكن
      await _saveToken(await FirebaseMessaging.instance.getToken(
        vapidKey:
        "BPrMwlKcWc5sD--u28IM_Xs_UqF7PHIBdu7sso1-zS-aIlSKukD7agXeuYoCINZdQ3_Azc_zIum4oGZS5sHNXdE",
      ));

      // إذا Firebase غيرت التوكن
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
        await _saveToken(newToken);
      });
    } else {
      print("❌ رفض الإذن بالإشعارات");
    }
  }

  /// 🔹 دالة حفظ التوكن في التخزين + الباك
  Future<void> _saveToken(String? token) async {
    if (token != null) {
      print("✅ Current FCM Token: $token");
      box.write("fcm_token", token);
      await ApiService.saveDeviceToken(token);
    }
  }

  /// 🔹 Listeners للإشعارات
  void _setupNotificationListeners() {
    // 🟢 Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📨 Foreground إشعار جديد وصل!");
      print("📩 وصلك إشعار (Foreground) كامل:");
      print(message.toMap());  // بيطبع كل شي بالرسالة
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
      print("Data: ${message.data}");

      Get.snackbar(
        message.notification?.title ?? "إشعار",
        message.notification?.body ?? "",
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(10),
        borderRadius: 10,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        overlayBlur: 2,
      );
    });

    // 🟢 عند الضغط على الإشعار (التطبيق بالخلفية)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("👉 التطبيق فتح من إشعار!");
      print("Data: ${message.data}");

      final route = message.data['route'];
      if (route != null) {
        Get.toNamed(route); // 🔹 روح للصفحة المطلوبة
      } else {
        Get.snackbar("فتح إشعار", message.notification?.body ?? "");
      }
    });

    // 🟢 تشغيل التطبيق من إشعار (كان مغلق)
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("🚀 تشغيل التطبيق من إشعار!");
        print("Data: ${message.data}");

        final route = message.data['route'];
        if (route != null) {
          Future.delayed(Duration.zero, () {
            Get.toNamed(route);
          });
        } else {
          Get.snackbar("تم فتح من إشعار", message.notification?.body ?? "");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = box.read('isLoggedIn') == true;

    return GetMaterialApp(
      title: 'Flutter Web Demo',
      theme: ThemeData(useMaterial3: true),
      home: isLoggedIn ? DashboardPage() : const AnimatedIntroPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
