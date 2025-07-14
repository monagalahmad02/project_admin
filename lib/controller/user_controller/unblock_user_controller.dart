import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../main.dart'; // يحتوي على baseUrl

class UnblockUserController extends GetxController {
  final storage = GetStorage();

  var isLoading = false.obs;

  Future<bool> unblockUser(int userId) async {
    isLoading.value = true;

    try {
      final token = storage.read('token');
      if (token == null) {
        Get.snackbar("Error", "Token not found");
        return false;
      }

      final url = Uri.parse('$baseUrl/admin/$userId/unblock');
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final message = data['message'] ?? 'User unblocked successfully';
        Get.snackbar("Success", message);
        return true;
      } else {
        Get.snackbar("Error", "Failed to unblock user: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
