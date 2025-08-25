import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../../model/user_model.dart';

class User7Controller extends GetxController {
  var isLoading = false.obs;
  var user = Rxn<UserModel>();

  final box = GetStorage();

  Future<void> fetchUserDetails(int userId) async {
    final url = Uri.parse("${baseUrl}/admin/User/$userId");
    final token = box.read("token");

    if (token == null) {
      Get.snackbar("Error", "Token not found");
      return;
    }

    try {
      isLoading.value = true;

      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List && data.isNotEmpty) {
          // إذا الـ API رجع Array
          user.value = UserModel.fromJson(Map<String, dynamic>.from(data[0]));
        } else if (data is Map && data.isNotEmpty) {
          // إذا الـ API رجع Object واحد
          user.value = UserModel.fromJson(Map<String, dynamic>.from(data));
        }
      } else {
        final error = jsonDecode(response.body);
        Get.snackbar("Error ❌", error["message"] ?? "فشل في جلب بيانات المستخدم");
      }
    } catch (e) {
      Get.snackbar("Exception", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
