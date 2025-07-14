import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:project3admin/main.dart';
import '../../model/dashboard2_model.dart'; // استبدله بمسار الموديل الصحيح

class Dashboard2Controller extends GetxController {
  final box = GetStorage(); // للحصول على التوكن
  final String url = '$baseUrl/admin/dashboard/lounges';

  var isLoading = true.obs;
  var dashboardData = Rxn<Dashboard2Data>();

  @override
  void onInit() {
    fetchDashboardData();
    super.onInit();
  }

  Future<void> fetchDashboardData() async {
    try {
      isLoading.value = true;

      final token = box.read('token');

      if (token == null) {
        print("❌ لا يوجد توكن محفوظ!");
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          dashboardData.value = Dashboard2Data.fromJson(jsonData['data']);
        } else {
          print('⚠️ API status != success');
        }
      } else {
        print('❌ HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
