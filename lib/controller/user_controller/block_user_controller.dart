import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../main.dart';

class BlockUserController extends GetxController {
  final storage = GetStorage();

  var isBlocking = false.obs;
  var blockMessage = ''.obs;

  Future<void> blockUsers(List<int> userIds) async {
    isBlocking.value = true;
    blockMessage.value = '';

    try {
      final token = storage.read('token');
      if (token == null) {
        Get.snackbar("Error", "Token not found");
        return;
      }

      for (final userId in userIds) {
        final url = Uri.parse('$baseUrl/admin/$userId/block');
        final response = await http.post(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final message = data['message'];
          blockMessage.value = message;
          Get.snackbar("Success", "User $userId blocked: $message");
        } else {
          Get.snackbar("Error", "Failed to block user $userId: ${response.statusCode}");
        }
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while blocking users: $e");
    } finally {
      isBlocking.value = false;
    }
  }
}
