import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OfficeManagementPage extends StatelessWidget {
  OfficeManagementPage({super.key});

  final Hall2Controller controller = Get.put(Hall2Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Office Management", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You have 200 Halls', style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),

            // الفلتر
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
              ),
              child: Row(
                children: [
                  const Icon(Icons.list, color: Colors.black),
                  const SizedBox(width: 15),
                  Obx(() {
                    final GlobalKey containerKey = GlobalKey();

                    return GestureDetector(
                      onTap: () async {
                        final RenderBox renderBox = containerKey.currentContext!.findRenderObject() as RenderBox;
                        final Offset offset = renderBox.localToGlobal(Offset.zero);
                        final Size size = renderBox.size;

                        final selected = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromLTRB(offset.dx, offset.dy + size.height, offset.dx + size.width, offset.dy),
                          constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.06), // يجعل القائمة بنفس العرض
                          items: const [
                            PopupMenuItem(value: 'All', child: Text('All', style: TextStyle(fontSize: 18),)),
                            PopupMenuItem(value: 'Subscriber', child: Text('Subscriber',  style: TextStyle(fontSize: 18),)),
                            PopupMenuItem(value: 'Not Subscriber', child: Text('Not Subscriber',  style: TextStyle(fontSize: 18),)),
                          ],
                        );

                        if (selected != null) {
                          controller.updateFilter(selected);
                        }
                      },
                      child: Container(
                        key: containerKey, // مهم جداً لتحديد الموقع والحجم
                        width: MediaQuery.of(context).size.width * 0.12,
                        height: MediaQuery.of(context).size.width * 0.025,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text(controller.selectedFilter.value,
                                style: const TextStyle(fontSize: 16,)),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_down_outlined),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            Obx(() => _buildTable(context, controller.filteredHalls)),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> halls) {
    final tableWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: tableWidth,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1), // الحواف الخارجية فقط
      ),
      child: Column(
        children: [
          Container(
            width: tableWidth,
            color: const Color.fromRGBO(75, 114, 210, 0.5),
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Row(
              children: [
                Expanded(flex: 1, child: Center(child: Text('ID'))),
                Expanded(flex: 3, child: Center(child: Text('Hall Name'))),
                Expanded(flex: 3, child: Center(child: Text('Acceptance Date'))),
                Expanded(flex: 2, child: Center(child: Text('Hour'))),
                Expanded(flex: 2, child: Center(child: Text('Subscribe'))),
              ],
            ),
          ),
          SizedBox(
            width: tableWidth,
            child: DataTable(
              headingRowHeight: 0, // إخفاء الرأس الافتراضي لأنه لديك رأس مخصص
              columnSpacing: 0,
              dividerThickness: 0, // إزالة الخطوط بين الصفوف
              dataRowColor: MaterialStateProperty.all(Colors.white),
              columns: const [
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
                DataColumn(label: SizedBox.shrink()),
              ],
              rows: halls.map((hall) {
                return DataRow(cells: [
                  DataCell(
                    SizedBox(
                      width: tableWidth * 1 / 11,
                      child: Center(child: Text(hall['id'].toString())),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: tableWidth * 3 / 11,
                      child: Center(
                        child: GestureDetector(
                          onTap: () => _navigateToHallDetails(context, hall['id']),
                          child: Text(
                            hall['name'],
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: tableWidth * 3 / 11,
                      child: Center(child: Text(hall['date'])),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: tableWidth * 2 / 11,
                      child: Center(child: Text(hall['hour'])),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      width: tableWidth * 2 / 11,
                      child: Center(
                        child: Text(
                          "Subscribe",
                          style: TextStyle(
                            color: hall['subscribe'] ? Colors.green : Colors.black,
                            fontWeight: hall['subscribe'] ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),

                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHallDetails(BuildContext context, int hallId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HallDetailsPage(hallId: hallId),
      ),
    );
  }
}

class HallDetailsPage extends StatelessWidget {
  final int hallId;

  const HallDetailsPage({super.key, required this.hallId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hall Details - ID: $hallId")),
      body: Center(
        child: Text(
          "Details for Hall ID: $hallId",
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}


class Hall2Controller extends GetxController {
  // القيمة المختارة من الفلتر
  var selectedFilter = 'All'.obs;

  // البيانات الأصلية (من الباك)
  final allHalls = [
    {'id': 1, 'name': 'Sunset Hall', 'date': '2024-05-10', 'hour': '14:00', 'subscribe': true},
    {'id': 2, 'name': 'Golden Palace', 'date': '2024-05-12', 'hour': '18:30', 'subscribe': false},
  ];

  // بيانات مفلترة بناءً على الفلتر
  List<Map<String, dynamic>> get filteredHalls {
    if (selectedFilter.value == 'Subscriber') {
      return allHalls.where((e) => e['subscribe'] == true).toList();
    } else if (selectedFilter.value == 'Not Subscriber') {
      return allHalls.where((e) => e['subscribe'] == false).toList();
    } else {
      return allHalls;
    }
  }

  void updateFilter(String newFilter) {
    selectedFilter.value = newFilter;
  }
}
