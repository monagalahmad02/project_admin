import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller/get_user_blocked_controller.dart';
import '../../controller/user_controller/unblock_user_controller.dart';


class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final BlockedUsersController blockedUsersController = Get.put(BlockedUsersController());
  final UnblockUserController unblockUserController = Get.put(UnblockUserController());

  @override
  Widget build(BuildContext context) {
    blockedUsersController.fetchBlockedUsers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Blocked Users'),
      ),
      body: Obx(() {
        if (blockedUsersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (blockedUsersController.blockedUsers.isEmpty) {
          return const Center(child: Text('No blocked users found', style: TextStyle(fontSize: 18)));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: blockedUsersController.blockedUsers.length,
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final user = blockedUsersController.blockedUsers[index];
            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.photo != null
                      ? NetworkImage(user.photo!)
                      : const AssetImage('assets/image/hall4.png') as ImageProvider,
                  radius: 25,
                ),
                title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.email),
                    const SizedBox(height: 4),
                    Text('Location: ${user.location}'),
                    Text('Role: ${user.role}'),
                  ],
                ),
                trailing: ElevatedButton(
                  onPressed: () async {
                    bool success = await unblockUserController.unblockUser(user.id);
                    if (success) {
                      // إعادة تحميل قائمة المستخدمين المحظورين بعد فك الحظر
                      await blockedUsersController.fetchBlockedUsers();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  child: unblockUserController.isLoading.value
                      ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Text('Unblock', style: TextStyle(color: Colors.white)),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
