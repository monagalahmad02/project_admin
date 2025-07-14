import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:project3admin/main.dart';
import 'package:get_storage/get_storage.dart';

class SubscriptionController extends GetxController {
  final box = GetStorage();

  var duration = 30.obs;
  var value = ''.obs;
  var currency = ''.obs;

  final List<int> durationOptions  = [30, 60, 90 , 120];

  Future<void> sendSubscriptionData() async {
    print('🔍 Starting to send data...');

    String? token = box.read('token');
    print('📦 Token: $token');

    final url = Uri.parse('$baseUrl/admin/settings/update');
    print('🌐 Request URL: $url');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    print('📋 Headers: $headers');

    final int parsedDuration = duration.value;
    final double parsedValue = double.tryParse(value.value) ?? 0.0;
    final String formattedCurrency = currency.value;

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
        print('✅ Data sent successfully!');
        Get.snackbar(
          'Success',
          'Subscription data updated successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF4CAF50),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        print('❌ Failed to send data. Status code: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to update subscription data.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFF44336),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('⚠️ Error occurred while sending data: $e');
      Get.snackbar(
        'Error',
        'An error occurred while sending data.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFF44336),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }
}
