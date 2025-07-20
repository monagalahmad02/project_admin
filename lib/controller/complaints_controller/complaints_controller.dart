import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/complaints_model.dart'; // تأكد من المسار الصحيح للـ model

class ComplaintsController extends GetxController {
  final int hallId; // ✅ تعريف hallId هنا

  ComplaintsController(this.hallId); // ✅ استقبال القيمة عبر الكونستركتر

  final complaints = <ComplaintsModel>[].obs;
  final isLoading = false.obs;

  final box = GetStorage();

  Future<void> fetchComplaints() async {
    isLoading.value = true;

    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Unauthorized', 'No token found in storage.');
      isLoading.value = false;
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/admin/complaints/$hallId'); // ✅ استخدم hallId

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        complaints.value =
            jsonList.map((json) => ComplaintsModel.fromJson(json)).toList();
      } else {
        final error = json.decode(response.body);
        Get.snackbar('Error', error['message'] ?? 'فشل في جلب الشكاوى.');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
