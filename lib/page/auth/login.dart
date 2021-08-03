import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/auth/action.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/component/custom_textformfield.dart';
import 'package:make_up/component/auth/header_auth.dart';
import 'package:make_up/component/auth/tagline.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/page/auth/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var formKey = GlobalKey<FormState>();

  AuthController authController = Get.find();
  bool hiddenPassword = true;

  double _opacity = 0;
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: PRIMARY_COLOR,
        body: Form(
          key: formKey,
          child: SafeArea(
            child: Stack(
              children: [
                SizedBox.expand(
                  child: AnimatedOpacity(
                    opacity: authController.loading.value ? .2 : 1.0,
                    duration: Duration(milliseconds: 200),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 30),
                              padding: const EdgeInsets.only(right: 140.0),
                              child: TagLine(),
                            ),
                            SizedBox(height: 20),
                            form(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Offstage(
                    offstage: !authController.loading.value,
                    child: CustomLinearProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: IgnorePointer(
        ignoring: authController.loading.value,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAuth(
                title: "Login",
                desc: "Please login with email password",
              ),
              SizedBox(
                height: 50,
              ),
              CustomTextFormField(
                'Email',
                controller: authController.emailController.value,
                type: TextInputType.emailAddress,
              ),
              CustomTextFormField(
                'Password',
                controller: authController.passwordController.value,
                obscureText: hiddenPassword,
                type: TextInputType.visiblePassword,
                action: TextInputAction.done,
                suffix: IconButton(
                  highlightColor: Colors.transparent,
                  icon: new Container(
                    width: 36.0,
                    child: new Icon(
                      hiddenPassword ? Icons.visibility_off : Icons.visibility,
                      color: SECONDARY_COLOR
                          .withOpacity(hiddenPassword ? 0.5 : 1.0),
                    ),
                  ),
                  onPressed: () =>
                      setState(() => hiddenPassword = !hiddenPassword),
                  splashColor: Colors.transparent,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ActionAuth(
                "Belum punya akun ?",
                hintButton: "Login",
                tapInkWell: () => Get.to(
                  RegisterPage(),
                  duration: Duration(milliseconds: 800),
                ),
                tapButton: () async {
                  if (formKey.currentState!.validate()) {
                    authController.loading.value = true;
                    Future.delayed(Duration(seconds: 10), () async {
                      await authController.login();
                    }).then((value) {
                      authController.showMessage(
                          'Connection timed out', SECONDARY_COLOR);
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    authController.loading.value = false;
    super.dispose();
  }
}
