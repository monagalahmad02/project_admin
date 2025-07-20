import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/auth_controller/login_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ✅ الخلفية - صور زخرفية
          Positioned(
            top: -15,
            right: -10,
            child: Image.asset(
              'assets/image/img.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset(
              'assets/image/img_3.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
          ),

          Center(
            child: Obx(() => Stack(
              children: [
                // ✅ واجهة تسجيل الدخول
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                  width: width * 0.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "please enter your details",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 25),

                      // ✅ البريد الإلكتروني
                      TextField(
                        controller: controller.emailController.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.email_outlined),
                          hintText: "Enter your email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // ✅ كلمة المرور
                      Obx(() => TextField(
                        controller: controller.passwordController.value,
                        obscureText: !controller.passwordVisible.value,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: "Enter your password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.passwordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              controller.passwordVisible.value =
                              !controller.passwordVisible.value;
                            },
                          ),
                        ),
                      )),
                      const SizedBox(height: 30),

                      // ✅ زر تسجيل الدخول
                      SizedBox(
                        width: width * 0.6,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.loginApi();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(103, 146, 203, 1),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: controller.loading.value
                              ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                              : const Text(
                            "Sign in",
                            style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ✅ مؤشر تحميل يغطي الشاشة إذا كان جاري تسجيل الدخول
                if (controller.loading.value)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
