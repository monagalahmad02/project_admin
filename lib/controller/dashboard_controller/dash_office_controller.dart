import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/dash_office_model.dart';

class DashOfficeController extends GetxController {
  var dashOffice = Rxn<DashOfficeModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDashOfficeData();
  }

  Future<void> fetchDashOfficeData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final token = box.read('token');
      if (token == null) {
        errorMessage.value = 'Token not found in storage';
        return;
      }

      final url = Uri.parse('http://127.0.0.1:8000/api/admin/dashboard/offices');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['status'] == 'success') {
          dashOffice.value = DashOfficeModel.fromJson(jsonData['data']);
        } else {
          errorMessage.value = 'API returned error: ${jsonData['status']}';
        }
      } else {
        errorMessage.value = 'Failed with status code: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
