import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project3admin/main.dart';

import '../../controller/user_controller/get_user_blocked_controller.dart';
import '../../controller/user_controller/unblock_user_controller.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final BlockedUsersController blockedUsersController = Get.put(BlockedUsersController());
  final UnblockUserController unblockUserController = Get.put(UnblockUserController());
  final RxInt currentlyUnblocking = (-1).obs; // ⬅️ لتتبع الزر المضغوط حاليًا

  @override
  Widget build(BuildContext context) {
    // ✅ استدعِها مرة واحدة فقط بعد بناء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      blockedUsersController.fetchBlockedUsers();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: Obx(() {
        if (blockedUsersController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (blockedUsersController.blockedUsers.isEmpty) {
          return const Center(
              child: Text('No blocked users found', style: TextStyle(fontSize: 18)));
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
                  backgroundImage: user.photo != null && user.photo!.isNotEmpty
                      ? NetworkImage('$baseUrl1/${user.photo!}')
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
                trailing: Obx(() {
                  final isThisLoading = currentlyUnblocking.value == user.id;

                  return ElevatedButton(
                    onPressed: () async {
                      currentlyUnblocking.value = user.id;
                      bool success = await unblockUserController.unblockUser(user.id);
                      if (success) {
                        await blockedUsersController.fetchBlockedUsers();
                      }
                      currentlyUnblocking.value = -1;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: isThisLoading
                        ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Unblock', style: TextStyle(color: Colors.white)),
                  );
                }),
              ),
            );
          },
        );
      }),
    );
  }
}
