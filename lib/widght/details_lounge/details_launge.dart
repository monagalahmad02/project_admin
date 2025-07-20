import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/complaints_controller/complaints_controller.dart';
import '../../controller/hall_controller/hall_details_controller.dart';
import '../../controller/hall_controller/hall_accpte_controller.dart';
import '../../controller/feedback_controller/feedback_controller.dart';
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
  late final FeedbackController feedbackController;
  late final ComplaintsController complaintsController;

  @override
  void initState() {
    super.initState();

    if (Get.isRegistered<HallsDetailsController>()) {
      Get.delete<HallsDetailsController>();
    }
    controller = Get.put(HallsDetailsController(widget.hallId));

    if (Get.isRegistered<FeedbackController>()) {
      Get.delete<FeedbackController>();
    }
    feedbackController = Get.put(FeedbackController());
    feedbackController.fetchReviews(widget.hallId);

    if (Get.isRegistered<ComplaintsController>()) {
      Get.delete<ComplaintsController>();
    }
    complaintsController = Get.put(ComplaintsController(widget.hallId));
    complaintsController.fetchComplaints();

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

      final imageUrl = (hall.hallImage != null &&
              hall.hallImage != 'null' &&
              !hall.hallImage!.contains('/null'))
          ? hall.hallImage!.startsWith('http')
              ? hall.hallImage!
              : '$baseUrl1/${hall.hallImage}'
          : null;

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
                    const SizedBox(height: 12),
                    Obx(() {
                      final avg =
                          feedbackController.feedback.value?.averageRating ??
                              0.0;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < avg.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 28,
                          );
                        }),
                      );
                    }),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (hall.owner?.id != null) {
                      Get.find<HallsController>().selectedOwnerId.value = hall.owner!.id;
                    } else {
                      Get.snackbar('خطأ', 'معرّف المالك غير موجود');
                    }
                  },
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: (hall.owner?.photo != null && hall.owner!.photo!.isNotEmpty)
                        ? NetworkImage('$baseUrl1/${hall.owner!.photo!}')
                        : const AssetImage('assets/image/hall4.png') as ImageProvider,
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
                        final imagePath = hall.images![index].imagePath;
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
                    ),
            ),
            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الشكاوى
                Container(
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    color: Colors.grey.shade200,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text('Complaints',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 8),
                      Obx(() {
                        if (complaintsController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (complaintsController.complaints.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: Text("لا توجد شكاوى حالياً."),
                          );
                        }

                        return SizedBox(
                          height: 300,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: complaintsController.complaints.length,
                            itemBuilder: (context, index) {
                              final complaint = complaintsController.complaints[index];
                              final user = complaint.user;

                              final userPhoto = (user?.photo != null && user!.photo!.isNotEmpty)
                                  ? '$baseUrl1/${user.photo}'
                                  : null;

                              return Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                    top: BorderSide(color: Colors.black, width: 0.5),
                                    bottom: BorderSide(color: Colors.black, width: 0.25),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage: userPhoto != null
                                          ? NetworkImage(userPhoto)
                                          : const AssetImage('assets/image/hall4.png') as ImageProvider,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user?.name ?? "مستخدم مجهول",
                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            complaint.complaint ?? '',
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // قسم التعليقات (Feedback)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.grey.shade200,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Feedback',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          if (feedbackController.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (feedbackController
                                  .feedback.value?.reviews?.isEmpty ??
                              true) {
                            return const Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("لا توجد تعليقات حالياً."),
                            );
                          }

                          return SizedBox(
                            height: 300,
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: feedbackController.feedback.value!.reviews!.length,
                              itemBuilder: (context, index) {
                                final review = feedbackController.feedback.value!.reviews![index];
                                final user = review.user;
                                final userPhoto = (user?.photo != null && user!.photo!.isNotEmpty)
                                    ? '$baseUrl1/${user.photo}'
                                    : null;

                                return Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      top: BorderSide(color: Colors.black, width: 0.5),
                                      bottom: BorderSide(color: Colors.black ,width: 0.25),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: userPhoto != null
                                            ? NetworkImage(userPhoto)
                                            : const AssetImage('assets/image/hall4.png') as ImageProvider,
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user?.name ?? "مستخدم مجهول",
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              review.comment ?? '',
                                              style: const TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
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
      color: backgroundColor ?? Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildValueCell(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.normal),
      ),
    );
  }
}
