import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/notification_model.dart';
import '../../main.dart';

class NotificationController extends GetxController {
  final box = GetStorage();

  // 🟢 قائمة الإشعارات
  var notifications = <NotificationModel>[].obs;

  // 🟢 حالة التحميل
  var isLoading = false.obs;

  // 🟢 عدد الإشعارات غير المقروءة
  var unreadCount = 0.obs;

  // ✅ تخزين IDs الإشعارات اللي انعرضت عشان ما تتكرر
  final Set<int> shownNotifications = {};

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();

    // كل 30 ثانية شيّك على إشعارات جديدة
    Timer.periodic(const Duration(seconds: 30), (timer) {
      fetchNotifications();
    });
  }

  /// 🔹 جلب الإشعارات من السيرفر
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;

      final token = box.read("token");
      if (token == null) return;

      final response = await http.get(
        Uri.parse("$baseUrl/notifications"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data["data"];
        final List<NotificationModel> fetchedList =
        list.map((e) => NotificationModel.fromJson(e)).toList();

        // 🟢 دمج الإشعارات الجديدة فقط إذا كانت غير موجودة مسبقًا
        for (var notif in fetchedList) {
          if (!notifications.any((n) => n.id == notif.id)) {
            notifications.add(notif);
          }
        }

        // 🟢 تحديث العداد
        unreadCount.value = notifications.where((n) => n.isRead == 0).length;

        // ✅ عرض Snackbar للإشعارات الجديدة الغير مقروءة
        for (var notif in notifications) {
          if (notif.isRead == 0 && !shownNotifications.contains(notif.id)) {
            shownNotifications.add(notif.id); // حفظه عشان ما يتكرر
            Get.snackbar(
              notif.title ?? "إشعار جديد",
              notif.body ?? "",
              snackPosition: SnackPosition.TOP,
              margin: const EdgeInsets.all(10),
              borderRadius: 10,
              backgroundColor: Colors.black87,
              colorText: Colors.white,
              duration: const Duration(seconds: 5),
              overlayBlur: 2,
            );
          }
        }
      } else {
        print("خطأ: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 خطأ fetchNotifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔹 تعليم الإشعار كمقروء
  Future<void> turnRead(int id) async {
    try {
      final token = box.read("token");
      if (token == null) return;

      final response = await http.put(
        Uri.parse("$baseUrl/notifications/turnRead/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        int index = notifications.indexWhere((notif) => notif.id == id);
        if (index != -1) {
          notifications[index] = notifications[index].copyWith(isRead: 1);
          notifications.refresh();

          // 🟢 تحديث العداد
          unreadCount.value =
              notifications.where((n) => n.isRead == 0).length;
        }
      } else {
        print("خطأ turnRead: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 خطأ turnRead: $e");
    }
  }
}
