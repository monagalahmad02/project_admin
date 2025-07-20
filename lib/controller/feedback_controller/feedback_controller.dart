import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/feedback_model.dart';

class FeedbackController extends GetxController {
  final feedback = Rxn<FeedbackModel>(); // Nullable at the beginning
  final isLoading = false.obs;

  final box = GetStorage();

  Future<void> fetchReviews(int hallId) async {
    isLoading.value = true;

    final token = box.read('token');
    if (token == null) {
      Get.snackbar('Unauthorized', 'No token found in storage.');
      isLoading.value = false;
      return;
    }

    final url = Uri.parse("http://127.0.0.1:8000/api/halls/$hallId/reviews");

    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        feedback.value = FeedbackModel.fromJson(jsonBody);
      } else {
        final jsonBody = json.decode(response.body);
        Get.snackbar('Error', jsonBody['message'] ?? 'Failed to fetch reviews.');
      }
    } catch (e) {
      Get.snackbar('Exception', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
