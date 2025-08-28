import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../model/hall_accpted_model.dart';
import 'package:project3admin/main.dart';

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
      filtered = hallsList.where((e) {
        if (e.subscriptionExpiresAt == null) return false;
        final expiry = DateTime.tryParse(e.subscriptionExpiresAt!);
        if (expiry == null) return false;
        return expiry.isAfter(DateTime.now());
      }).toList();
    } else if (selectedFilter.value == 'Not Subscriber') {
      filtered = hallsList.where((e) {
        if (e.subscriptionExpiresAt == null) return true;
        final expiry = DateTime.tryParse(e.subscriptionExpiresAt!);
        if (expiry == null) return true;
        return expiry.isBefore(DateTime.now());
      }).toList();
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
        'subscribe': hall.subscriptionExpiresAt != null &&
            DateTime.tryParse(hall.subscriptionExpiresAt!)?.isAfter(DateTime.now()) == true,
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
        print("❌ Error: Token is null");
        Get.snackbar('Error', 'Token is null');
        isLoading(false);
        return;
      }

      print("➡️ Sending GET request to: $baseUrl/halls");
      final response = await http.get(
        Uri.parse('$baseUrl/halls'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      print("📦 Raw response body: ${response.body}");
      print("📄 Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        try {
          var jsonData = jsonDecode(response.body);

          if (jsonData is List) {
            hallsList.value =
                jsonData.map((hall) => HallsModel.fromJson(hall)).toList();
            print("✅ Parsed ${hallsList.length} halls from List JSON");
          } else if (jsonData is Map && jsonData.containsKey('data')) {
            hallsList.value = (jsonData['data'] as List)
                .map((hall) => HallsModel.fromJson(hall))
                .toList();
            print("✅ Parsed ${hallsList.length} halls from Map['data'] JSON");
          } else {
            print("⚠️ Unexpected JSON structure: ${jsonData.runtimeType}");
          }

          // طباعة كل تفاصيل القاعات
          for (var hall in hallsList) {
            print("------ Hall Details ------");
            print("ID: ${hall.id}");
            print("Name: ${hall.name}");
            print("Owner ID: ${hall.ownerId}");
            print("Location: ${hall.location}");
            print("Capacity: ${hall.capacity}");
            print("Type: ${hall.type}");
            print("Events: ${hall.events}");
            print("Contact: ${hall.contact}");
            print("Pay Methods: ${hall.payMethods}");
            print("Status: ${hall.status}");
            print("Rate: ${hall.rate}");
            print("Subscription Expires At: ${hall.subscriptionExpiresAt}");
            print("Created At: ${hall.createdAt}");
            print("Updated At: ${hall.updatedAt}");
            print("Reviews Avg Rating: ${hall.reviewsAvgRating}");
            print("Images: ${hall.images}");
            print("Video: ${hall.video}");
            print("Prices: ${hall.prices}");
            print("Reviews: ${hall.reviews}");
            print("---------------------------");
          }

        } catch (e) {
          print("❌ JSON Parsing Error: $e");
          Get.snackbar('Error', 'JSON Parsing Error: $e');
        }
      } else {
        print("❌ HTTP Error: Status code ${response.statusCode}");
        Get.snackbar('Error', 'Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Exception caught: $e");
      Get.snackbar('Error', 'Failed to fetch halls: $e');
    } finally {
      isLoading(false);
      print("⏹ Finished fetching halls. Total loaded: ${hallsList.length}");
    }
  }
}
