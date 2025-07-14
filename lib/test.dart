import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/accpte_a_hall_controller/accpte_hall_controller.dart';
import '../../controller/hall_controller/hall_pending_controller.dart';
import '../../model/hall_pending_model.dart';
import '../../main.dart';

class HallDetailsRequestPage extends StatelessWidget {
  final HallPending hall;
  final VoidCallback onBack;

  const HallDetailsRequestPage(
      {Key? key, required this.hall, required this.onBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AccepectHallsController hallsController =
    Get.find<AccepectHallsController>();
    final AcceptAHallController acceptController =
    Get.find<AcceptAHallController>();

    // بديل لـ firstWhereOrNull
    final hallDetails = hallsController.hallsList.firstWhere(
          (h) => h.id == hall.id,
      orElse: () => hall,
    );

    final imageUrl = (hall.hallImage != null &&
        hall.hallImage != 'null' &&
        !hall.hallImage!.contains('/null'))
        ? (hall.hallImage!.startsWith('http')
        ? hall.hallImage!
        : '$baseUrl1/${hall.hallImage}')
        : null;

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
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height *
                      0.45, // 65% من ارتفاع الشاشة
                  width: MediaQuery.of(context).size.height *
                      0.8, // العرض كما تريد
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl != null
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/image/hall4.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hall.name ?? 'اسم غير متوفر',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async{
                        await acceptController.accept(hall.id);
                        hallsController.hallsList.removeWhere((h) => h.id == hall.id);

                        Get.back(); // ترجع للصفحة السابقة فقط إذا تمت الموافقة بنجاح
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
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
                const Spacer(),
                // GestureDetector(
                //   onTap: () {
                //     if (hallDetails.owner?.id != null) {
                //       hallsController.selectedOwnerId.value = hallDetails.owner!.id;
                //     } else {
                //       Get.snackbar('خطأ', 'معرّف المالك غير موجود');
                //     }
                //   },
                //   child: CircleAvatar(
                //     radius: 30,
                //     backgroundImage: (hallDetails.owner?.photo != null && hallDetails.owner!.photo!.isNotEmpty)
                //         ? NetworkImage(hallDetails.owner!.photo!)
                //         : const AssetImage('assets/image/hall4.png') as ImageProvider,
                //   ),
                // ),
              ],
            ),
            const SizedBox(height: 16),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
                4: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(75, 114, 210, 0.5),
                  ),
                  children: [
                    _buildHeaderCell("نوع القاعة"),
                    _buildHeaderCell("السعة"),
                    _buildHeaderCell("الهاتف"),
                    _buildHeaderCell("الموقع"),
                    _buildHeaderCell("الحالة"),
                  ],
                ),
                TableRow(
                  children: [
                    _buildValueCell(hall.type ?? 'غير معروف'),
                    _buildValueCell("${hall.capacity} شخص"),
                    _buildValueCell(hall.contact ?? 'غير متوفر'),
                    _buildValueCell(hall.location ?? 'غير متوفر'),
                    _buildValueCell(hall.status ?? "غير معروف"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 35),
            Container(
              color: Colors.grey.shade200,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              child: const Center(
                child: Text(
                  "الصور",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: (hall.images == null || hall.images!.isEmpty)
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
                itemCount: hall.images!.length,
                itemBuilder: (context, index) {
                  final imagePath = hall.images![index];
                  final imageFullUrl = '$baseUrl1/$imagePath';

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      imageFullUrl,
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 150,
                          height: 100,
                          color: Colors.grey.shade200,
                          alignment: Alignment.center,
                          child: const Text("⚠️ تعذر تحميل الصورة"),
                        );
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(width: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildValueCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        textAlign: TextAlign.center,
      ),
    );
  }
}
