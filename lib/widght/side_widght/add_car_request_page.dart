import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'hall_managment_page.dart';

class AddCarOfficeRequestsPage extends StatelessWidget {
  AddCarOfficeRequestsPage({super.key});

  final Hall3Controller controller = Get.put(Hall3Controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Request to add a car office",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Obx(() => Text(
              'You have ${controller.allHalls.length} request',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            )),

            const SizedBox(height: 16),

            Expanded(
              child: SingleChildScrollView(
                child: Obx(() => _buildTable(context, controller.allHalls)),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> halls) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black), // حافة خارجية فقط
        color: Colors.white,
      ),
      child: Table(
        border: TableBorder.symmetric(
          inside: BorderSide.none, // إلغاء الحدود الداخلية
          outside: const BorderSide(color: Colors.black), // يمكنك إبقاء الحافة الخارجية إن أردت
        ),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(2),
        },
        children: [
          _buildTableHeader(),
          ...halls.map((hall) => _buildTableRow(hall)).toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      decoration: const BoxDecoration(
        color: Color.fromRGBO(75, 114, 210, 0.5),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Hall Name', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Order Date', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Hour', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(child: Text('Procedure', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
      ],
    );
  }

  TableRow _buildTableRow(Map<String, dynamic> hall) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hall['id'].toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hall['name'].toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hall['date'].toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hall['hour'].toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () {
                final Hall3Controller controller = Get.find<Hall3Controller>();
                controller.allHalls.removeWhere((h) => h['id'] == hall['id']);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green, // لون النص
                side: const BorderSide(color: Colors.green), // الحواف الخضراء
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),

              child: const Text("Accept"),
            ),
          ),
        ),
      ],
    );
  }

}


class Hall3Controller extends GetxController {
  final RxList<Map<String, dynamic>> allHalls = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    allHalls.addAll([
      {
        'id': 1,
        'name': 'Sunset Hall',
        'date': '2024-05-10',
        'hour': '14:00',
        'subscribe': true
      },
      {
        'id': 2,
        'name': 'Golden Palace',
        'date': '2024-05-12',
        'hour': '18:30',
        'subscribe': false
      },
    ]);
    super.onInit();
  }
}
