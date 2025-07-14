import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/accpte_a_hall_controller/accpte_hall_controller.dart';
import '../../controller/hall_controller/hall_details_controller.dart';
import '../../controller/hall_controller/hall_pending_controller.dart';
import '../../model/hall_pending_model.dart';
import '../details_lounge/hall_details_request_page.dart';

class AddHallRequestsPage extends StatelessWidget {
  AddHallRequestsPage({Key? key}) : super(key: key);

  final AccepectHallsController controller = Get.put(AccepectHallsController());
  final AcceptAHallController controller2 = Get.put(AcceptAHallController());

  final Rx<HallPending?> selectedHall = Rx<HallPending?>(null);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (selectedHall.value != null) {
        Get.put(HallsDetailsController(selectedHall.value!.id));
        return HallDetailsRequestPage(
          hall: selectedHall.value!,
          onBack: () => selectedHall.value = null,
        );
      }

      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request to add a hall',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'You have ${controller.hallsList.length} request(s)',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.hallsList.isEmpty
                      ? const Center(child: Text("No pending halls requests."))
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _buildTable(context, controller.hallsList),
                        ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTable(BuildContext context, List<HallPending> halls) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Table(
        border: TableBorder.all(color: Colors.black),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1),
          4: FlexColumnWidth(1),
        },
        children: [
          _buildTableHeader(),
          ...halls.map(_buildTableRow).toList(),
        ],
      ),
    );
  }

  TableRow _buildTableHeader() {
    return const TableRow(
      decoration: BoxDecoration(color: Color.fromRGBO(75, 114, 210, 0.5)),
      children: [
        Padding(padding: EdgeInsets.all(8.0), child: Center(child: Text(''))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Hall Name'))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Order Date'))),
        Padding(
            padding: EdgeInsets.all(8.0), child: Center(child: Text('Hour'))),
        Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text('Procedure'))),
      ],
    );
  }

  TableRow _buildTableRow(HallPending hall) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(hall.id.toString())),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: InkWell(
              onTap: () => selectedHall.value = hall,
              child: Text(
                hall.name,
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(formatDate(hall.createdAt))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: Text(formatTime(hall.updatedAt))),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: ElevatedButton(
              onPressed: () async {
                await controller2.accept(hall.id);
                controller.hallsList.removeWhere((h) => h.id == hall.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                side: const BorderSide(color: Colors.green),
              ),
              child: const Text("Accept"),
            ),
          ),
        ),
      ],
    );
  }

  String formatDate(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('yyyy-MM-dd').format(dateTime);
    } catch (_) {
      return dateTimeString;
    }
  }

  String formatTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('HH:mm').format(dateTime);
    } catch (_) {
      return dateTimeString;
    }
  }
}
