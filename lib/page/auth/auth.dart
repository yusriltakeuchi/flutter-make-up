import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/component/auth/tagline.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/page/auth/login.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(milliseconds: 5500), () {
      return Get.to(
        LoginPage(),
        duration: Duration(milliseconds: 2500),
      );
    });

    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox.expand(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TagLine(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: CustomLinearProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
