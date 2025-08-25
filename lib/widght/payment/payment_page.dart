import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/payment_controller/payment_controller.dart';

class PaymentsPage extends StatelessWidget {
  final PaymentController controller = Get.put(PaymentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments List'),
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
                title: Text('Number payment: ${payment.id}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: \$${(payment.amount / 100).toStringAsFixed(2)}'),
                    Text('Currency: ${payment.currency.toUpperCase()}'),
                    Text('Status: ${payment.status}'),
                    if (payment.metadata != null && payment.metadata!['type'] != null)
                      Text('Type: ${payment.metadata!['type']}'),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
