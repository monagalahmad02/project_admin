import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

import '../../main.dart';

class DeleteUserController extends GetxController {
  final storage = GetStorage();
  var selectedUsers = <String>[].obs;
  var isDeleting = false.obs;
  var deleteMessage = ''.obs;

  Future<void> deleteUsers(List<int> userIds) async {
    isDeleting.value = true;
    deleteMessage.value = '';

    try {
      final token = storage.read('token');
      print('Token: $token');

      if (token == null) {
        Get.snackbar("Error", "Token not found");
        return;
      }

      for (final userId in userIds) {
        final url = Uri.parse('$baseUrl/admin/delete/$userId');
        print('Deleting user ID: $userId');
        print('URL: $url');

        final response = await http.delete(
          url,
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        );

        print('Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final message = data['message'];
          deleteMessage.value = message;
          print('Success Message: $message');
        } else {
          Get.snackbar("Error", "Failed to delete user $userId: ${response.statusCode}");
        }
      }

      Get.snackbar("Success", "Users deleted successfully");

    } catch (e) {
      print('Exception: $e');
      Get.snackbar("Error", "An error occurred while deleting users: $e");
    } finally {
      isDeleting.value = false;
    }
  }
}
