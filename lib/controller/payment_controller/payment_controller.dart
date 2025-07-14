import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../model/payment_model.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;
  var payments = <PaymentIntent>[].obs;

  final box = GetStorage();
  final String apiUrl = 'http://127.0.0.1:8000/api/stripe/getPayments';

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;

      final token = box.read('token');
      if (token == null) {
        Get.snackbar('خطأ', 'لم يتم العثور على التوكن');
        return;
      }

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final paymentModel = PaymentModel.fromJson(jsonData);
        payments.assignAll(paymentModel.data);
      } else {
        Get.snackbar('خطأ', 'فشل في جلب البيانات: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الاتصال: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
