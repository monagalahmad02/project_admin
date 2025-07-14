import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../../main.dart';
import '../../model/hall_details_model.dart';

class HallsDetailsController extends GetxController {
  var hallDetails = Rxn<HallsDetailsModel>();
  var isLoading = true.obs;
  final box = GetStorage();
  int hallId;

  HallsDetailsController(this.hallId);

  @override
  void onInit() {
    super.onInit();
    debugPrint('🚀 جلب بيانات القاعة ID: $hallId');
    getDetailsAllHalls(hallId);
  }

  Future<void> getDetailsAllHalls(int hallId) async {
    print('🔍 جلب بيانات القاعة ID: $hallId');

    try {
      isLoading(true);
      String? token = box.read('token');
      if (token == null) {
        Get.snackbar('خطأ', 'التوكن غير موجود');
        isLoading(false);
        return;
      }

      var response = await http.get(
        Uri.parse('$baseUrl/halls/$hallId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📡 استجابة API: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        print('${response.statusCode}');

        if (jsonData != null && jsonData is List && jsonData.isNotEmpty) {
          hallDetails.value = HallsDetailsModel.fromJson(jsonData[0]);
          print('✅ تم تحميل بيانات القاعة: ${hallDetails.value}');
        } else {
          print('⚠️ البيانات غير صحيحة أو فارغة!');
        }
      } else {
        print('❌ خطأ في الاستجابة: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ استثناء عند جلب البيانات: $e');
    } finally {
      isLoading(false);
    }
  }
}
