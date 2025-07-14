import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project3admin/main.dart';
import 'package:get_storage/get_storage.dart';

class SubscriptionOfficeController extends GetxController {
  final box = GetStorage();

  var officeDuration = 30.obs;
  var officeValue = ''.obs;
  var officeCurrency = ''.obs;

  final List<int> durationOptions = [30, 60, 90, 120];

  Future<void> sendSubscriptionData() async {
    print('🔍 Starting to send office subscription data...');

    String? token = box.read('token');
    print('📦 Token: $token');

    final url = Uri.parse('$baseUrl/admin/settings/office/update');
    print('🌐 Request URL: $url');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('📋 Headers: $headers');

    final int parsedDuration = officeDuration.value;
    final double parsedValue = double.tryParse(officeValue.value) ?? 0.0;
    final String formattedCurrency = officeCurrency.value;

    final body = jsonEncode({
      'subscription_duration_days': parsedDuration,
      'subscription_value': parsedValue,
      'currency': formattedCurrency,
    });

    print('📤 Request Body: $body');

    try {
      final response = await http.put(
        url,
        headers: headers,
        body: body,
      );

      print('📨 Response status: ${response.statusCode}');
      print('📨 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Office subscription data sent successfully!');
        Get.snackbar(
          'Success',
          'Office subscription data updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        print('❌ Failed to send office data. Status code: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to update office subscription data.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('⚠️ Error occurred while sending office data: $e');
      Get.snackbar(
        'Error',
        'An error occurred while sending office subscription data.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
