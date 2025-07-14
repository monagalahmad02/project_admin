import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:project3admin/main.dart';

// UserController.dart
class UserController extends GetxController {
  var selectedFilter = 'All'.obs;

  var halls = <Map<String, dynamic>>[].obs;

  var selectedHalls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('$baseUrl/admin/allUsers');

    // استدعاء GetStorage
    final box = GetStorage();
    final token = box.read('token') ?? '';

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // إضافة التوكن هنا
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        halls.value = data.map((e) => e as Map<String, dynamic>).toList();
      } else {
        print('Failed to load users: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }
  List<Map<String, dynamic>> get filteredHalls {
    if (selectedFilter.value == 'All') return halls;
    return halls.where((u) => u['role'] == selectedFilter.value).toList();
  }

  void updateFilter(String filter) {
    selectedFilter.value = filter;
    clearSelection();
  }

  void selectHall(String id) {
    if (!selectedHalls.contains(id)) selectedHalls.add(id);
  }

  void deselectHall(String id) {
    selectedHalls.remove(id);
  }

  void selectAll(List<Map<String, dynamic>> list) {
    selectedHalls.value = list.map((e) => e['id'].toString()).toList();
  }

  void clearSelection() {
    selectedHalls.clear();
  }

  bool isAllSelected(List<Map<String, dynamic>> list) {
    if (list.isEmpty) return false;
    return selectedHalls.length == list.length;
  }

  void deleteSelected() {
    halls.removeWhere((u) => selectedHalls.contains(u['id'].toString()));
    clearSelection();
  }
}
