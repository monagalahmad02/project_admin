import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/count_notification_model.dart';
import '../../main.dart';

class CountNotificationController extends GetxController {
  final box = GetStorage();

  var count = 0.obs;
  var isLoading = false.obs;

  Future<void> fetchCount() async {
    try {
      isLoading.value = true;

      final token = box.read("token");

      if (token == null) {
        print("❌ ما في توكن محفوظ");
        return;
      }

      final response = await http.get(
        Uri.parse("$baseUrl/notifications/unreadCount"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final model = CountNotificationModel.fromJson(data);
        count.value = model.notifications;
      } else {
        print("❌ خطأ: ${response.statusCode}");
      }
    } catch (e) {
      print("🚨 خطأ: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
