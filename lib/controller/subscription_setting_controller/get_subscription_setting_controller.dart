import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/subscription_setting_model.dart';
import 'package:project3admin/main.dart'; // تأكد من مسار هذا الملف عندك

class SubscriptionSettingController extends GetxController {
  var subscriptionSetting = Rxn<SubscriptionSettingModel>();
  var isLoading = false.obs;
  final storage = GetStorage();

  final String apiUrl = '$baseUrl/admin/settings'; // عدل حسب API الخاص بك

  Future<void> fetchSubscriptionSetting() async {
    try {
      isLoading.value = true;
      final token = storage.read('token');
      if (token == null) throw Exception('Token not found');

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        subscriptionSetting.value = SubscriptionSettingModel.fromJson(data);
      } else {
        throw Exception('Failed to load subscription setting');
      }
    } catch (e) {
      print('Error fetching subscription setting: $e');
    } finally {
      isLoading.value = false;
    }
  }
}


