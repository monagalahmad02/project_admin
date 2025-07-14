import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/payment_controller/payment_controller.dart';

class PaymentsPage extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المدفوعات'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.payments.isEmpty) {
          return const Center(child: Text('لا توجد مدفوعات متاحة.'));
        }

        return ListView.builder(
          itemCount: controller.payments.length,
          itemBuilder: (context, index) {
            final payment = controller.payments[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 4,
              child: ListTile(
                title: Text('ID: ${payment.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('المبلغ: \$${(payment.amount / 100).toStringAsFixed(2)}'),
                    Text('العملة: ${payment.currency.toUpperCase()}'),
                    Text('الحالة: ${payment.status}'),
                    if (payment.metadata != null && payment.metadata!['type'] != null)
                      Text('النوع: ${payment.metadata!['type']}'),
                  ],
                ),
                trailing: Icon(Icons.payment, color: Colors.blue),
              ),
            );
          },
        );
      }),
    );
  }
}
