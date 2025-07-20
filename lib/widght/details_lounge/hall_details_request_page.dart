import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/accpte_a_hall_controller/accpte_hall_controller.dart';
import '../../controller/hall_controller/hall_accpte_controller.dart';
import '../../controller/hall_controller/hall_pending_controller.dart';
import '../../controller/home_controller/home_controller.dart';
import '../../model/hall_pending_model.dart';
import '../../main.dart';
import '../profile_owner_page/profile_owner_page.dart';

class HallDetailsRequestPage extends StatelessWidget {
  final HallPending hall;
  final VoidCallback onBack;

  const HallDetailsRequestPage({
    Key? key,
    required this.hall,
    required this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccepectHallsController hallsController = Get.find<AccepectHallsController>();
    final AcceptAHallController acceptController = Get.find<AcceptAHallController>();

    Get.put(HallsController());
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: onBack,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: (hall.hallImage != null &&
                      hall.hallImage != 'null' &&
                      !hall.hallImage!.contains('/null'))
                      ? Image.network(
                    hall.hallImage!.startsWith('http')
                        ? hall.hallImage!
                        : '$baseUrl1/${hall.hallImage}',
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.4,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const Text("❌ خطأ في تحميل الصورة"),
                  )
                      : Image.asset(
                    'assets/image/hall4.png',
                    height: screenHeight * 0.4,
                    width: screenWidth * 0.4,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hall.name ?? 'اسم غير متوفر',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: () async {
                          await acceptController.accept(hall.id);
                          hallsController.hallsList.removeWhere((h) => h.id == hall.id);
                          onBack();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (hall.owner?.id != null) {
                      Get.find<HomeController>().selectedOwnerId.value = hall.owner!.id;
                    } else {
                      Get.snackbar('خطأ', 'معرّف المالك غير موجود');
                    }
                  },                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: (hall.owner?.photo != null &&
                        hall.owner!.photo!.isNotEmpty)
                        ? NetworkImage(hall.owner!.photo!.startsWith('http')
                        ? hall.owner!.photo!
                        : '$baseUrl1/${hall.owner!.photo!}')
                        : const AssetImage('assets/image/hall4.png')
                    as ImageProvider,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


            Table(
              border: const TableBorder(
                top: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
              ),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(children: [
                  _buildHeaderCell(
                    "Lounge type",
                    backgroundColor: const Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                  _buildHeaderCell(
                    "Capacity",
                    backgroundColor: const Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                  _buildHeaderCell(
                    "Phone",
                    backgroundColor: const Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                  _buildHeaderCell(
                    "Location",
                    backgroundColor: const Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                  _buildHeaderCell(
                    "Subscribe",
                    backgroundColor: const Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                ]),
                TableRow(children: [
                  _buildValueCell(
                    (hall.type != null && hall.type!.toLowerCase() == 'both')
                        ? 'joys and sorrows'
                        : (hall.type ?? 'غير معروف'),
                  ),
                  _buildValueCell("${hall.capacity} person"),
                  _buildValueCell(hall.contact ?? 'غير متوفر'),
                  _buildValueCell(hall.location ?? 'غير متوفر'),
                  _buildValueCell(hall.status ?? "Subscribed"),
                ]),
              ],
            ),


            const SizedBox(height: 30),

            // عنوان الصور
            Container(
              color: Colors.grey.shade200,
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              child: const Text(
                'الصور',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // صور القاعة
            SizedBox(
              height: 100,
              child: (hall.images.isEmpty)
                  ? Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    '📷 لا توجد صور متوفرة لهذه القاعة',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              )
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: hall.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final imagePath = hall.images[index].imagePath;
                  final imageFullUrl = '$baseUrl1/$imagePath';

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageFullUrl,
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 150,
                        height: 100,
                        color: Colors.grey.shade200,
                        alignment: Alignment.center,
                        child: const Text("⚠️ تعذر تحميل الصورة"),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildHeaderCell(String text, {Color? backgroundColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: backgroundColor ?? Colors.grey.shade300,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildValueCell(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
