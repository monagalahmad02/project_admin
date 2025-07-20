import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../model/owner_model.dart';

class ProfileOwnerController extends GetxController {
  final box = GetStorage();

  var owner = Rxn<OwnerModel>();
  var isLoading = false.obs;

  final String apiUrl = '$baseUrl/admin/User';
  final int userId;

  ProfileOwnerController(this.userId);

  @override
  void onInit() {
    super.onInit();
    fetchOwnerProfile(userId);
  }

  Future<void> fetchOwnerProfile(int userId) async {
    isLoading.value = true;
    print('بدء جلب بيانات الأونر للمعرف: $userId');

    try {
      String? token = box.read('token');
      print('تم قراءة التوكن: $token');

      if (token == null) {
        Get.snackbar('خطأ', 'التوكن غير موجود');
        print('التوكن غير موجود، إيقاف العملية');
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse('$apiUrl/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('حصلنا على رد من السيرفر، رمز الحالة: ${response.statusCode}');
      print('نص الرد: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('تم فك تشفير JSON: $jsonData');

        if (jsonData is List && jsonData.isNotEmpty) {
          owner.value = OwnerModel.fromJson(jsonData[0]);
        } else {
          Get.snackbar('خطأ', 'البيانات المستلمة فارغة أو غير متوقعة');
        }
      }

    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء جلب بيانات الأونر');
      print('حدث استثناء أثناء جلب البيانات: $e');
    } finally {
      isLoading.value = false;
      print('انتهت عملية جلب بيانات الأونر');
    }
  }
}
