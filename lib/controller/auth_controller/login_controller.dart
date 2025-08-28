import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../main.dart';
import '../../model/login_model.dart';
import '../../widght/dashboard_page/dashboard_page.dart';
import '../notification_controller/save_fcm_token_controller.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  RxBool passwordVisible = false.obs;
  RxBool loading = false.obs;

  void loginApi() async {
    final box = GetStorage();
    loading.value = true;

    try {
      final response = await post(
        Uri.parse('$baseUrl/login'),
        body: {
          'email': emailController.value.text,
          'password': passwordController.value.text,
        },
      );

      print(response.statusCode);

      // تحقق من نوع المحتوى
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        var data = jsonDecode(response.body);
        print(data);

        if (response.statusCode == 200) {
          if (data['message'] != null) {
            // ✅ خزّن التوكن
            LoginModel loginData = LoginModel.fromJson(data);
            await box.write('token', loginData.token);
            await box.write('isLoggedIn', true);

            // ✅ جيب FCM token
            String? fcmToken = await FirebaseMessaging.instance.getToken();
            if (fcmToken != null) {
              await ApiService.saveDeviceToken(fcmToken);
            }

            // ✅ الانتقال للداشبورد
            Get.offAll(() => DashboardPage());
          } else {
            Get.snackbar('Login Successful', 'No message received.');
          }
        } else {
          Get.snackbar('Error', 'Failed to login: ${data['error'] ?? 'Unknown error'}');
        }
      } else {
        Get.snackbar('Error', 'Received non-JSON response: ${response.body}');
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar('Exception', e.toString());
    } finally {
      loading.value = false;
    }
  }
}
