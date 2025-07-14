import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:project3admin/main.dart';
import '../../model/hall_accpted_model.dart';

class HallsController extends GetxController {
  var hallsList = <HallsModel>[].obs;
  var isLoading = true.obs;

  final box = GetStorage();

  var selectedFilter = 'All'.obs;
  RxnInt selectedHallId = RxnInt();
  var selectedOwnerId = Rxn<int>(null);


  /// فلترة القاعات حسب الاشتراك وتحويلها إلى Map لعرضها في الجدول
  List<Map<String, dynamic>> get filteredHalls {
    List<HallsModel> filtered;

    if (selectedFilter.value == 'Subscriber') {
      filtered = hallsList.where((e) => e.isSubscribe == true).toList();
    } else if (selectedFilter.value == 'Not Subscriber') {
      filtered = hallsList.where((e) => e.isSubscribe != true).toList();
    } else {
      filtered = hallsList;
    }

    return filtered.map((hall) {
      String dateOnly = '';
      if (hall.createdAt != null && hall.createdAt!.isNotEmpty) {
        dateOnly = hall.createdAt!.split('T').first;
      }

      String hourOnly = '';
      if (hall.updatedAt != null && hall.updatedAt!.isNotEmpty) {
        hourOnly = hall.updatedAt!.split('T').last.split('.').first;
      }

      return {
        'id': hall.id,
        'name': hall.name ?? '',
        'date': dateOnly,
        'hour': hourOnly,
        'subscribe': hall.isSubscribe == true,
      };
    }).toList();
  }

  void updateFilter(String newFilter) {
    selectedFilter.value = newFilter;
  }

  void selectHall(int id) {
    print("Selected from Controller: $id");
    selectedHallId.value = id;
  }

  void clearSelection() {
    selectedOwnerId.value = null;
    selectedHallId.value = null;
    hallsList.clear();

    // تأجيل تنفيذ getAllHalls بعد تغيير الحالة
    Future.delayed(const Duration(milliseconds: 100), () {
      getAllHalls();
    });
  }


  @override
  void onInit() {
    super.onInit();
    getAllHalls();
  }

  Future<void> getAllHalls() async {
    try {
      isLoading(true);
      String? token = box.read('token');
      if (token == null) {
        Get.snackbar('Error', 'Token is null');
        isLoading(false);
        return;
      }


      final response = await http.get(
        Uri.parse('$baseUrl/halls'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      print('Raw halls JSON: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData is List) {
          hallsList.value =
              jsonData.map((hall) => HallsModel.fromJson(hall)).toList();
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          hallsList.value = (jsonData['data'] as List)
              .map((hall) => HallsModel.fromJson(hall))
              .toList();
        }
      } else {
        Get.snackbar('Error', 'Status code: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch halls: $e');
    } finally {
      isLoading(false);
    }

    for (var hall in hallsList) {
      print(
          'Hall: ${hall.name}, isSubscribe: ${hall.isSubscribe}, createdAt: ${hall.createdAt}, updatedAt: ${hall.updatedAt}');
    }
  }
}
