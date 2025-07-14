import 'dart:convert';
import 'dart:html';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';

class AcceptAHallController extends GetxController {
  RxBool isLoading = false.obs;
  final box = GetStorage();

  Future<void> accept(int hallId, {VoidCallback? onSuccess}) async {
    isLoading.value = true;
    String? token = box.read('token');

    if (token == null) {
      Get.snackbar('Error', 'Token is null');
      isLoading(false);
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/admin/status/$hallId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': 'approved'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Hall accepted successfully');
        onSuccess?.call(); // ✅ استدعاء الكول باك إذا تم بنجاح
      } else {
        Get.snackbar('Error', 'Failed to accept hall');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to send request');
    } finally {
      isLoading.value = false;
    }
  }
}
