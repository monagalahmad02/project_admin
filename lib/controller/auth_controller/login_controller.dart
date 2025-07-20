import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../../main.dart';
import '../../model/login_model.dart';
import '../../widght/dashboard_page/dashboard_page.dart';

class LoginController extends GetxController {

  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  RxBool passwordVisible = false.obs; // ⬅️ أضف هذا
  RxBool loading = false.obs;

  void loginApi() async {
    final box = GetStorage();
    try {
      final response = await post(
          Uri.parse('$baseUrl/login'),
          body: {
            'email': emailController.value.text,
            'password': passwordController.value.text,
          });

      print(response.statusCode);

      // تحقق من نوع المحتوى
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        var data = jsonDecode(response.body);

        print(data);

        if (response.statusCode == 200) {
          if (data['message'] != null) {
            LoginModel loginData = LoginModel.fromJson(data);
            await box.write('token', loginData.token);
            await box.write('isLoggedIn', true);
            Get.to(() => DashboardPage());
          } else {
            Get.snackbar('Login Successful', 'No message received.');
          }
        } else {
          // معالجة رمز الحالة غير 200
          Get.snackbar('Error', 'Failed to login: ${data['error'] ?? 'Unknown error'}');
        }
      } else {
        Get.snackbar('Error', 'Received non-JSON response: ${response.body}');
      }
    } catch (e) {
      loading.value = false;
      print(e.toString());
      Get.snackbar('Exception', e.toString());
    } finally {
      loading.value = false; // تأكد من إعادة تعيين حالة التحميل في النهاية
    }
  }
}
