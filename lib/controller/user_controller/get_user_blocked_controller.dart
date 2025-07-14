import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../main.dart';
import '../../model/user_blocked_model.dart';  // لتوفير baseUrl

class BlockedUsersController extends GetxController {
  final storage = GetStorage();

  var blockedUsers = <UserBlockedModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchBlockedUsers() async {
    isLoading.value = true;

    try {
      final token = storage.read('token');
      if (token == null) {
        print("Token not found in storage.");
        Get.snackbar("Error", "Token not found");
        return;
      }

      final url = Uri.parse('$baseUrl/admin/blocked');
      print("Fetching blocked users from: $url");

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        blockedUsers.value = data.map((e) => UserBlockedModel.fromJson(e)).toList();
        print("Blocked users loaded: ${blockedUsers.length}");
      } else {
        print("Failed to load blocked users, status code: ${response.statusCode}");
        Get.snackbar("Error", "Failed to load blocked users: ${response.statusCode}");
      }
    } catch (e, stacktrace) {
      print("Error occurred while fetching blocked users:");
      print(e);
      print(stacktrace);
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
