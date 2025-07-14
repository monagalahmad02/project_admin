import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../model/hall_pending_model.dart';

class AccepectHallsController extends GetxController {
  var hallsList = <HallPending>[].obs;
  var isLoading = true.obs;

  var selectedOwnerId = Rxn<int>();

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    getAllHalls();
  }

  Future<void> getAllHalls() async {
    try {
      print('Start fetching halls...');
      isLoading(true);

      String? token = box.read('token');
      print('Token read from storage: $token');

      if (token == null) {
        Get.snackbar('Error', 'Token is null');
        print('Error: Token is null');
        isLoading(false);
        return;
      }

      final url = '$baseUrl/admin/pending';
      print('Fetching from URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('Decoded JSON data type: ${jsonData.runtimeType}');
        print('Decoded JSON data: $jsonData');

        if (jsonData is List) {
          hallsList.value = jsonData
              .map((hall) => HallPending.fromJson(hall))
              .toList();
          print('Parsed halls count: ${hallsList.length}');

          // مثال لاختيار أول معرّف مالك (إذا موجود)
          if (hallsList.isNotEmpty && hallsList.first.ownerId != null) {
            selectedOwnerId.value = hallsList.first.ownerId;
            print('Selected owner ID: ${selectedOwnerId.value}');
          } else {
            print('Owner ID is null in the first hall');
          }
        } else if (jsonData is Map && jsonData.containsKey('data')) {
          var dataList = jsonData['data'] as List;
          hallsList.value = dataList
              .map((hall) => HallPending.fromJson(hall))
              .toList();
          print('Parsed halls count: ${hallsList.length}');

          if (hallsList.isNotEmpty && hallsList.first.ownerId != null) {
            selectedOwnerId.value = hallsList.first.ownerId;
            print('Selected owner ID: ${selectedOwnerId.value}');
          } else {
            print('Owner ID is null in the first hall');
          }
        } else {
          print('Unexpected JSON structure');
        }
      } else {
        Get.snackbar('Error', 'Status code: ${response.statusCode}');
        print('Error: Server responded with status code ${response.statusCode}');
      }
    } catch (e, stacktrace) {
      Get.snackbar('Error', 'Failed to fetch halls: $e');
      print('Exception caught: $e');
      print('Stacktrace: $stacktrace');
    } finally {
      isLoading(false);
      print('Finished fetching halls.');
    }
  }
}
