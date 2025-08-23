import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/dashboard1_model.dart';
import '../../main.dart'; // حيث يوجد baseUrl

class Dashboard1Controller extends GetxController {
  final box = GetStorage();
  final String baseUrl2 = '$baseUrl/admin/dashboard/general';

  var isLoading = true.obs;
  var dashboardData = Rxn<DashboardData>();
  var errorMessage = ''.obs; // لتخزين أي خطأ

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = box.read('token');
      if (token == null) {
        errorMessage.value = "❌ لا يوجد توكن مخزن";
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl2),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'success') {
          dashboardData.value = DashboardData.fromJson(decoded['data']);
        } else {
          errorMessage.value = "⚠️ API Error: ${decoded['status']}";
        }
      } else {
        errorMessage.value = "⚠️ HTTP Error ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      errorMessage.value = '❌ Exception: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
