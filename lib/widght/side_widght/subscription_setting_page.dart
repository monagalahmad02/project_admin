import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/subscription_setting_controller/get_subscription_setting_controller.dart';
import '../../controller/subscription_setting_controller/update_subscription_setting_controller.dart';
import '../../controller/subscription_setting_office_controller/get_subscription_setting_office_controller.dart';
import '../../controller/subscription_setting_office_controller/update_subscription_setting_office_controller.dart';

class SubscriptionSettingPage extends StatefulWidget {
  const SubscriptionSettingPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionSettingPage> createState() => _SubscriptionSettingPageState();
}

class _SubscriptionSettingPageState extends State<SubscriptionSettingPage> {
  final SubscriptionController controller = Get.put(SubscriptionController());
  final SubscriptionSettingController settingController = Get.put(SubscriptionSettingController());

  final SubscriptionSettingOfficeController settingOfficeController = Get.put(SubscriptionSettingOfficeController());
  final SubscriptionOfficeController subscriptionOfficeController = Get.put(SubscriptionOfficeController());

  final TextEditingController textController = TextEditingController();
  final LayerLink _officeLayerLink = LayerLink();
  OverlayEntry? _dropdownOverlay;
  final List<String> periods = ['month', 'two month', 'year'];

  void toggleDropdown() {
    if (_dropdownOverlay == null) {
      _showDropdown();
    } else {
      _removeDropdown();
    }
  }

  void _showDropdown() {
    final overlay = Overlay.of(context);
    _dropdownOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width * 0.2,
        child: CompositedTransformFollower(
          link: _officeLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 55),
          child: Material(
            elevation: 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: periods
                    .map((period) => InkWell(
                  onTap: () => selectPeriod(period),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(period),
                  ),
                ))
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
    overlay?.insert(_dropdownOverlay!);
  }

  void _removeDropdown() {
    _dropdownOverlay?.remove();
    _dropdownOverlay = null;
  }

  void selectPeriod(String period) {
    textController.text = period;
    _removeDropdown();
  }

  Future<void> _refreshPage() async {
    await settingController.fetchSubscriptionSetting();
    await settingOfficeController.fetchSubscriptionSetting();
  }

  @override
  void dispose() {
    _removeDropdown();
    textController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    settingController.fetchSubscriptionSetting();
    settingOfficeController.fetchSubscriptionSetting();
  }

  @override
  Widget build(BuildContext context) {
    final double mainContentWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: mainContentWidth,
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      'Subscription Settings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: buildSubscriptionCard(
                          title: 'Add a lounge subscription',
                          durationWidget: Obx(() => DropdownButtonFormField<int>(
                            value: controller.duration.value == 0
                                ? null
                                : controller.duration.value,
                            decoration: const InputDecoration(
                              labelText: 'Subscription duration (days)',
                              border: OutlineInputBorder(),
                            ),
                            items: controller.durationOptions
                                .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text('$d days'),
                            ))
                                .toList(),
                            onChanged: (value) =>
                            controller.duration.value = value ?? 0,
                          )),
                          onSave: controller.sendSubscriptionData,
                          valueOnChanged: (v) => controller.value.value = v,
                          currencyOnChanged: (v) => controller.currency.value = v ?? '',
                        ),
                      ),
                      const SizedBox(width: 60),
                      Flexible(
                        flex: 2,
                        child: Obx(() {
                          if (settingController.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final setting = settingController.subscriptionSetting.value;
                          if (setting == null) {
                            return const Center(child: Text('No subscription data available'));
                          }
                          return buildDisplayCard(
                            'Lounge subscription',
                            '${setting.subscriptionDurationDays} days',
                            '${setting.subscriptionValue} ${setting.currency.toUpperCase()}',
                            context,
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: buildSubscriptionCard(
                          title: 'Add an office subscription',
                          durationWidget: Obx(() => DropdownButtonFormField<int>(
                            value: subscriptionOfficeController.officeDuration.value == 0
                                ? null
                                : subscriptionOfficeController.officeDuration.value,
                            decoration: const InputDecoration(
                              labelText: 'Subscription duration (days)',
                              border: OutlineInputBorder(),
                            ),
                            items: subscriptionOfficeController.durationOptions
                                .map((d) => DropdownMenuItem(
                              value: d,
                              child: Text('$d days'),
                            ))
                                .toList(),
                            onChanged: (value) =>
                            subscriptionOfficeController.officeDuration.value = value ?? 0,
                          )),
                          onSave: subscriptionOfficeController.sendSubscriptionData,
                          valueOnChanged: (v) => subscriptionOfficeController.officeValue.value = v,
                          currencyOnChanged: (v) => subscriptionOfficeController.officeCurrency.value = v ?? '',
                        ),
                      ),
                      const SizedBox(width: 60),
                      Flexible(
                        flex: 2,
                        child: Obx(() {
                          if (settingOfficeController.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final setting2 = settingOfficeController.subscriptionSetting.value;
                          if (setting2 == null) {
                            return const Center(child: Text('No subscription data available'));
                          }
                          return buildDisplayCard(
                            'office subscription',
                            '${setting2.subscriptionDurationDays} days',
                            '${setting2.subscriptionValue} ${setting2.currency.toUpperCase()}',
                            context,
                          );
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubscriptionCard({
    required String title,
    required Widget durationWidget,
    required VoidCallback onSave,
    required Function(String) valueOnChanged,
    required Function(String?) currencyOnChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey.shade200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 20)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // وظيفة تعديل يمكن إضافتها هنا
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: durationWidget,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Subscription value',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: valueOnChanged,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Currency',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'usd', child: Text('usd')),
                    DropdownMenuItem(value: 'syr', child: Text('syrian')),
                    DropdownMenuItem(value: 'EUR', child: Text('Dirham')),
                    DropdownMenuItem(value: 'GBP', child: Text('RAS')),
                  ],
                  onChanged: currencyOnChanged,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.1,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: onSave,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisplayCard(String title, String duration, String value, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(title),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: $duration', style: const TextStyle(fontSize: 18)),
                Text('Value: $value', style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
