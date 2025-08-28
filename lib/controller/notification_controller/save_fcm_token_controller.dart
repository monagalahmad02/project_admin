import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:project3admin/main.dart';

class ApiService {
  static Future<void> saveDeviceToken(String deviceToken) async {
    final storage = GetStorage();
    final authToken = storage.read('token');

    final url = Uri.parse('$baseUrl/save-device-token');

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $authToken",
    };

    final body = jsonEncode({
      "device_token": deviceToken,
    });

    // 🟢 اطبع كل المعلومات قبل الإرسال
    print("📡 Sending request to: $url");
    print("📑 Headers: $headers");
    print("📝 Body: $body");

    final response = await http.post(url, headers: headers, body: body);

    // // 🟢 اطبع كل معلومات الاستجابة
    // print("📥 Response Status: ${response.statusCode}");
    // print("📥 Response Body: ${response.body}");
    // print("📥 Response Headers: ${response.headers}");

    if (response.statusCode == 200) {
      print("✅ Success FCM token is saved ");
    } else {
      Get.snackbar("❌ Field", " FCM token is fielded: ${response.body}");
    }
  }
}
