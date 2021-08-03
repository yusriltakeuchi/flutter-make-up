import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/page/auth/auth.dart';
import 'package:make_up/page/home.dart';

class Root extends GetWidget<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() =>
        Get.find<AuthController>().isLogin.value ? HomePage() : AuthPage());
  }
}
