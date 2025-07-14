import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/hall_controller/hall_accpte_controller.dart';
import '../details_lounge/details_launge.dart';
import '../profile_owner_page/profile_owner_page.dart';

class HallManagementPage extends StatelessWidget {
  HallManagementPage({super.key});

  final HallsController controller = Get.put(HallsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Obx(() {
          final selectedHallId = controller.selectedHallId.value;
          final selectedOwnerId = controller.selectedOwnerId.value;

          if (selectedOwnerId != null) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    controller.selectedOwnerId.value = null;
                  },
                ),
                Expanded(child: ProfileOwnerPage(userId: selectedOwnerId)),
              ],
            );
          }

          if (selectedHallId != null) {
            return HallDetailsWidget(hallId: selectedHallId);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Hall Management",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),

              Obx(() => Text(
                  'You have ${controller.hallsList.length} Halls',
                  style: const TextStyle(fontSize: 16, color: Colors.grey))),
              const SizedBox(height: 35),

              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.grey.shade200),
                child: Row(
                  children: [
                    const Icon(Icons.list, color: Colors.black),
                    const SizedBox(width: 15),
                    Obx(() {
                      final GlobalKey containerKey = GlobalKey();
                      return GestureDetector(
                        onTap: () async {
                          final RenderBox renderBox =
                          containerKey.currentContext!
                              .findRenderObject() as RenderBox;
                          final Offset offset =
                          renderBox.localToGlobal(Offset.zero);
                          final Size size = renderBox.size;

                          final selected = await showMenu<String>(
                            context: context,
                            position: RelativeRect.fromLTRB(
                                offset.dx,
                                offset.dy + size.height,
                                offset.dx + size.width,
                                offset.dy),
                            constraints: BoxConstraints(
                                minWidth:
                                MediaQuery.of(context).size.width * 0.06),
                            items: const [
                              PopupMenuItem(
                                  value: 'All',
                                  child: Text('All',
                                      style: TextStyle(fontSize: 18))),
                              PopupMenuItem(
                                  value: 'Subscriber',
                                  child: Text('Subscriber',
                                      style: TextStyle(fontSize: 18))),
                              PopupMenuItem(
                                  value: 'Not Subscriber',
                                  child: Text('Not Subscriber',
                                      style: TextStyle(fontSize: 18))),
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
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            children: [
                              Text(controller.selectedFilter.value,
                                  style: const TextStyle(fontSize: 16)),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_down_outlined),
                            ],
                          ),
                        ),
                      );
                    }),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        print("🌀 Refresh pressed");
                        controller.clearSelection(); // ✅ التعديل هنا
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              Obx(() {
                if (controller.isLoading.value) {
                  return const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (controller.filteredHalls.isEmpty) {
                  return const Expanded(
                    child: Center(child: Text("No halls found.")),
                  );
                }

                return Expanded(
                  child: _buildTable(context, controller.filteredHalls),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTable(BuildContext context, List<Map<String, dynamic>> halls) {
    final tableWidth = MediaQuery.of(context).size.width * 0.8;

    return SingleChildScrollView(
      child: Container(
        width: tableWidth,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color.fromRGBO(75, 114, 210, 0.5),
              child: const Row(
                children: [
                  Expanded(child: Center(child: Text('', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                  Expanded(child: Center(child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                  Expanded(child: Center(child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                  Expanded(child: Center(child: Text('Hour', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                  Expanded(child: Center(child: Text('Subscribe', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))),
                ],
              ),
            ),
            ...halls.map((hall) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(hall['id'].toString(),
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          controller.selectHall(hall['id']);
                        },
                        child: Center(
                          child: Text(hall['name'].toString(),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(hall['date'],
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(hall['hour'],
                            style: const TextStyle(fontSize: 14)),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          hall['subscribe'] == true ||
                              hall['subscribe']
                                  .toString()
                                  .toLowerCase() ==
                                  'true'
                              ? 'subscriber'
                              : 'not subscriber',
                          style: TextStyle(
                            fontSize: 14,
                            color: (hall['subscribe'] == true ||
                                hall['subscribe']
                                    .toString()
                                    .toLowerCase() ==
                                    'true')
                                ? Colors.green
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
