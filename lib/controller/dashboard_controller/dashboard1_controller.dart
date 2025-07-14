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

  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  Future<void> fetchDashboardData() async {
    try {
      final token = box.read('token');
      if (token == null) {
        print("❌ لا يوجد توكن مخزن");
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(baseUrl2),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == 'success') {
          dashboardData.value = DashboardData.fromJson(decoded['data']);
        } else {
          print("⚠️ status != success");
        }
      } else {
        print("⚠️ HTTP Error ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
