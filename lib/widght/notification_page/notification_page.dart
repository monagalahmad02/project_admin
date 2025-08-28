import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notification_controller/get_notification_controller.dart';
import '../../model/notification_model.dart';


class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController controller = Get.put(NotificationController());

    // يجلب الإشعارات عند فتح الصفحة
    controller.fetchNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("لا يوجد إشعارات حالياً"),
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final NotificationModel notif = controller.notifications[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                leading: Icon(
                  notif.isRead == 0 ? Icons.notifications_active : Icons.done,
                  color: notif.isRead == 0 ? Colors.red : Colors.green,
                ),
                title: Text(
                  notif.title ?? "",
                  style: TextStyle(
                    fontWeight: notif.isRead == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                subtitle: Text(notif.body ?? ""),
                trailing: Text(
                  "${notif.createdAt.toLocal()}".split(".").first,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                onTap: () async {
                  if (notif.isRead == 0) {
                    await controller.turnRead(notif.id);
                  }
                },
              ),
            );
          },
        );
      }),
    );
  }
}
