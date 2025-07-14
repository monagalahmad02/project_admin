import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/get_profile_owner_controller/get_profile_owner_controller.dart';

class ProfileOwnerPage extends StatelessWidget {
  final int userId;

  const ProfileOwnerPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProfileOwnerController controller = Get.put(ProfileOwnerController(userId));

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final owner = controller.owner.value;

        if (owner == null) {
          return const Center(child: Text('لا توجد بيانات للمالك'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // عرض صورة المالك أو صورة افتراضية
              CircleAvatar(
                radius: 50,
                backgroundImage: owner.photo != null && owner.photo!.isNotEmpty
                    ? NetworkImage(owner.photo!)
                    : const AssetImage('assets/image/hall4.png') as ImageProvider,
              ),
              const SizedBox(height: 20),
              const Text('Full name', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              Container(
                height: 50,
                child: TextFormField(
                  initialValue: owner.name ?? 'غير متوفر',

                  readOnly: true,
                  textAlignVertical: TextAlignVertical.center, // توسيط عمودياً
                  decoration: InputDecoration(
                    contentPadding:const EdgeInsets.only(left: 20), // إزالة الهوامش الداخلية لتوسيط كامل
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                    fillColor: Colors.grey.shade300,
                    filled: true,
                  ),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email', style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: TextFormField(
                          initialValue: owner.email ?? 'غير متوفر',
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center, // توسيط عمودياً
                          decoration: InputDecoration(
                            contentPadding:const EdgeInsets.only(left: 20), // إزالة الهوامش الداخلية لتوسيط كامل
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Role', style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: TextFormField(
                          initialValue: owner.role ?? 'غير متوفر',
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center, // توسيط عمودياً
                          decoration: InputDecoration(
                            contentPadding:const EdgeInsets.only(left: 20), // إزالة الهوامش الداخلية لتوسيط كامل
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Location', style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: TextFormField(
                          initialValue: owner.location ?? 'غير متوفر',
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center, // توسيط عمودياً
                          decoration: InputDecoration(
                            contentPadding:const EdgeInsets.only(left: 20), // إزالة الهوامش الداخلية لتوسيط كامل
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Number', style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.37,
                        child: TextFormField(
                          initialValue: owner.number ?? 'غير متوفر',
                          readOnly: true,
                          textAlignVertical: TextAlignVertical.center, // توسيط عمودياً
                          decoration: InputDecoration(
                            contentPadding:const EdgeInsets.only(left: 20), // إزالة الهوامش الداخلية لتوسيط كامل
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                            fillColor: Colors.grey.shade300,
                            filled: true,
                          ),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

            ],
          ),
        );
      }),
    );
  }
}
