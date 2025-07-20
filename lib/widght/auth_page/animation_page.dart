import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'log_in_page.dart';
import 'login_page.dart';

class AnimatedIntroPage extends StatefulWidget {
  const AnimatedIntroPage({Key? key}) : super(key: key);

  @override
  State<AnimatedIntroPage> createState() => _AnimatedIntroPageState();
}

class _AnimatedIntroPageState extends State<AnimatedIntroPage> {
  bool _show = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _show = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          // الخلفية
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.5, -1.0),     // الأزرق يبدأ من الزاوية العلوية اليسرى أكثر
                end: Alignment(0.9, 1.2),         // الرمادي يسيطر أكثر نحو الأسفل واليمين
                colors: [
                  Color(0xFF498DE9),
                  Color(0xFF999999),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: -80,
            child: Image.asset(
              'assets/image/img_3.png',
              width: width * 0.3,
              height: height * 0.3,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            right: -90,
            child: Image.asset(
              'assets/image/img.png',
              width: width * 0.3,
              height: height * 0.3,
              fit: BoxFit.contain,
            ),
          ),

          // ✅ عنوان الصفحة
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            top: _show ? height * 0.35 : -100,    // نزلت النص أكثر
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "My Lounges",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // زر البداية
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            bottom: _show ? height * 0.40 : -100,  // رفعت الزر أكثر (زاد ارتفاعه)
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.to(() => (LoginPage()));
                },
                child: const Text(
                  "Start",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

}
