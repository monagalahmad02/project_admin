import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller/block_user_controller.dart';
import '../../controller/user_controller/delete_user_controller.dart';
import '../../controller/user_controller/user_controller.dart';

class UsersPage extends StatelessWidget {
  UsersPage({super.key});

  final UserController controller = Get.put(UserController());
  final BlockUserController blockController = Get.put(BlockUserController());
  final DeleteUserController deleteController = Get.put(DeleteUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hall Management",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('You have 200 Halls',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 16),
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
                        final RenderBox renderBox = containerKey.currentContext!
                            .findRenderObject() as RenderBox;
                        final Offset offset = renderBox.localToGlobal(Offset.zero);
                        final Size size = renderBox.size;

                        final selected = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                              offset.dx,
                              offset.dy + size.height,
                              offset.dx + size.width,
                              offset.dy),
                          constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.06),
                          items: const [
                            PopupMenuItem(value: 'All', child: Text('All', style: TextStyle(fontSize: 18))),
                            PopupMenuItem(value: 'Admin', child: Text('Admin', style: TextStyle(fontSize: 18))),
                            PopupMenuItem(value: 'owner', child: Text('Owner', style: TextStyle(fontSize: 18))),
                            PopupMenuItem(value: 'assistant', child: Text('Assistant', style: TextStyle(fontSize: 18))),
                            PopupMenuItem(value: 'client', child: Text('Client', style: TextStyle(fontSize: 18))),
                            PopupMenuItem(value: 'car services', child: Text('Car Services', style: TextStyle(fontSize: 18))),
                          ],
                        );

                        if (selected != null) {
                          controller.updateFilter(selected);
                        }
                      },
                      child: Container(
                        key: containerKey,
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
                                style: const TextStyle(
                                  fontSize: 16,
                                )),
                            const Spacer(),
                            const Icon(Icons.keyboard_arrow_down_outlined),
                          ],
                        ),
                      ),
                    );
                  }),
                  const Spacer(),
                  Obx(() {
                    return controller.selectedHalls.isNotEmpty
                        ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () async {
                            if (controller.selectedHalls.isNotEmpty) {
                              final ids = controller.selectedHalls.map((id) => int.parse(id)).toList();
                              await deleteController.deleteUsers(ids);
                              await controller.fetchUsers();
                              controller.clearSelection(); // (اختياري) لمسح التحديد
                            }
                          },

                        ),
                        const SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: TextButton(
                            onPressed: () async {
                            if (controller.selectedHalls.isNotEmpty) {
                              final ids = controller.selectedHalls.map((id) => int.parse(id)).toList();
                              await blockController.blockUsers(ids);
                              controller.clearSelection(); // (اختياري) لمسح التحديد
                            }
                          },

                            child: const Text('Block', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() => _buildTable(context, controller.filteredHalls)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> halls) {
    final tableWidth = MediaQuery.of(context).size.width * 0.8;

    return Container(
      width: tableWidth,
      child: Column(
        children: [
          Container(
            width: tableWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1), // ✅ الحواف الخارجية
              color: const Color.fromRGBO(75, 114, 210, 0.5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Row(
              children: [
                Obx(() {
                  return Checkbox(
                    value: controller.isAllSelected(halls),
                    onChanged: (val) {
                      if (val == true) {
                        controller.selectAll(halls);
                      } else {
                        controller.clearSelection();
                      }
                    },
                  );
                }),
                const Expanded(
                    flex: 3,
                    child: Center(
                        child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)))),
                const Expanded(
                    flex: 3,
                    child: Center(
                        child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)))),
                const Expanded(
                    flex: 2,
                    child: Center(
                        child: Text('Phone', style: TextStyle(fontWeight: FontWeight.bold)))),
                const Expanded(
                    flex: 2,
                    child: Center(
                        child: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)))),
              ],
            ),
          ),
          SizedBox(
            width: tableWidth,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: halls.length,
              itemBuilder: (context, index) {
                final hall = halls[index];
                final hallIdStr = hall['id'].toString();

                return Obx(() {
                  final isSelected = controller.selectedHalls.contains(hallIdStr);
                  return Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade100 : Colors.transparent,
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: isSelected,
                          onChanged: (val) {
                            if (val == true) {
                              controller.selectHall(hallIdStr);
                            } else {
                              controller.deselectHall(hallIdStr);
                            }
                          },
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(
                            child: Text(
                              hall['name'],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Center(child: Text(hall['email'] ?? '')),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(hall['number'] ?? '')),
                        ),
                        Expanded(
                          flex: 2,
                          child: Center(child: Text(hall['role'] ?? '')),
                        ),
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

}

