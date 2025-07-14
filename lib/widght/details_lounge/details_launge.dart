import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/hall_controller/hall_details_controller.dart';
import '../../controller/hall_controller/hall_accpte_controller.dart';
import '../../main.dart';
import '../profile_owner_page/profile_owner_page.dart';

class HallDetailsWidget extends StatefulWidget {
  final int hallId;

  HallDetailsWidget({required this.hallId});

  @override
  State<HallDetailsWidget> createState() => _HallDetailsWidgetState();
}

class _HallDetailsWidgetState extends State<HallDetailsWidget> {
  late final HallsDetailsController controller;

  @override
  void initState() {
    super.initState();

    // حذف Controller إذا كان مسجل مسبقًا
    if (Get.isRegistered<HallsDetailsController>()) {
      Get.delete<HallsDetailsController>();
    }

    // تسجيل Controller جديد مع معرف القاعة
    controller = Get.put(HallsDetailsController(widget.hallId));
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final hall = controller.hallDetails.value;

      if (hall == null) {
        return const Center(child: Text("❌ لم يتم العثور على تفاصيل القاعة."));
      }

      // التحقق من صحة رابط الصورة الرئيسية
      final imageUrl = (hall.hallImage != null &&
              hall.hallImage != 'null' &&
              !hall.hallImage!.contains('/null'))
          ? hall.hallImage!.startsWith('http')
              ? hall.hallImage!
              : '$baseUrl1/${hall.hallImage}'
          : null;

      print('Image URL: $imageUrl');

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: IconButton(
                    onPressed: () {
                      Get.find<HallsController>().clearSelection();
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.height * 0.8,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Text("❌ خطأ في تحميل الصورة");
                          },
                        )
                      : Image.asset(
                          'assets/image/hall4.png',
                          height: MediaQuery.of(context).size.height * 0.4,
                          width: MediaQuery.of(context).size.height * 0.8,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(width: 20),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      hall.name ?? 'اسم غير متوفر',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 12), // مسافة بين النص والزر
                    //
                    // // زر الاشتراك الأخضر
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // هنا تضيف كود الاشتراك أو أي دالة
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.green, // لون الخلفية أخضر
                    //     padding: const EdgeInsets.symmetric(
                    //         horizontal: 24, vertical: 12),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   child: const Text(
                    //     'Subscribe',
                    //     style: TextStyle(fontSize: 18, color: Colors.white),
                    //   ),
                    // ),

                    const SizedBox(height: 12), // مسافة بين الزر والنجوم

                    // صف النجوم (5 نجوم)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 28,
                        );
                      }),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (hall.owner?.id != null) {
                      Get.find<HallsController>().selectedOwnerId.value =
                          hall.owner!.id;
                    } else {
                      Get.snackbar('خطأ', 'معرّف المالك غير موجود');
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: (hall.owner?.photo != null &&
                            hall.owner!.photo!.isNotEmpty)
                        ? NetworkImage(hall.owner!.photo!)
                        : const AssetImage('assets/image/hall4.png')
                            as ImageProvider,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
            const SizedBox(height: 35),
            Container(
              color: Colors.grey.shade200,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              child: const Center(
                child: Text(
                  "the pictures",
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
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final imagePath =
                            hall.images![index].imagePath; // ✅ فقط imagePath
                        final imageFullUrl =
                            '$baseUrl1/$imagePath'; // ✅ تأكد من هذا

                        print("📸 صورة رقم ${index + 1}: $imageFullUrl");

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
                    ),
            ),
            const SizedBox(height: 35),
            Row(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Complaints'),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.blue.shade900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.37,
                      height: MediaQuery.of(context).size.height * 0.07,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        color: Colors.grey.shade200,
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Feedback'),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: TextButton(
                              onPressed: () {},
                              child: Text(
                                'View',
                                style: TextStyle(color: Colors.blue.shade900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
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
