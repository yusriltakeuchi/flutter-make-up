import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:make_up/component/auth/action.dart';
import 'package:make_up/component/const.dart';
import 'package:make_up/component/custom_dropdownField.dart';
import 'package:make_up/component/custom_linear_progress_indicator.dart';
import 'package:make_up/component/custom_textformfield.dart';
import 'package:make_up/component/auth/header_auth.dart';
import 'package:make_up/component/auth/tagline.dart';
import 'package:make_up/helper/auth/auth_controller.dart';
import 'package:make_up/page/auth/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var formKey = GlobalKey<FormState>();

  AuthController authController = Get.find();

  List<String> gender = [
    'pria',
    'wanita',
  ];

  double _opacity = 0;
  bool hiddenPassword = true;
  bool hiddenConfirmPassword = true;
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
                    child: IgnorePointer(
                      ignoring: authController.loading.value,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 30),
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
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      Offstage(
                        offstage: !authController.loading.value,
                        child: CustomLinearProgressIndicator(),
                      ),
                      Container(
                        color: PRIMARY_COLOR,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
                        child: ActionAuth(
                          "Sudah punya akun ?",
                          hintButton: "Register",
                          tapInkWell: () => Get.to(
                            LoginPage(),
                            duration: Duration(milliseconds: 800),
                          ),
                          tapButton: () => tapRegister(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  tapRegister() async {
    String? message;
    Color? color;
    String _pwd = authController.passwordController.value.text;
    String _confirmPwd = authController.passwordController.value.text;

    if (formKey.currentState!.validate()) {
      if (_pwd == _confirmPwd) {
        authController.loading.value = true;
        Future.delayed(Duration(seconds: 10), () async {
          await authController.register();
        }).then((value) {
          authController.showMessage('Connection timed out', SECONDARY_COLOR);
        });
      } else {
        color = SECONDARY_COLOR;
        message = "Password tidak sama";
        authController.showMessage(message, color);
      }
    } else {
      color = SECONDARY_COLOR;
      if (_pwd == _confirmPwd) {
        message = "Kolom tidak boleh kosong";
      } else {
        message = "Password tidak sama";
      }
      authController.showMessage(message, color);
    }
  }

  Widget form() {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAuth(
              title: "Register",
              desc: "Please enter your data correctly",
            ),
            SizedBox(
              height: 50,
            ),
            listForm(),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }

  Padding listForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          CustomTextFormField(
            'Email',
            controller: authController.emailController.value,
            type: TextInputType.emailAddress,
          ),
          CustomTextFormField(
            'Password',
            controller: authController.passwordController.value,
            obscureText: hiddenPassword,
            // type: TextInputType.te,
            action: TextInputAction.next,
            suffix: InkWell(
              onTap: () => setState(() => hiddenPassword = !hiddenPassword),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  hiddenPassword ? Icons.visibility_off : Icons.visibility,
                  color:
                      SECONDARY_COLOR.withOpacity(hiddenPassword ? 0.5 : 1.0),
                ),
              ),
            ),
          ),
          CustomTextFormField(
            'Confirm Password',
            controller: authController.confirmPasswordController.value,
            obscureText: hiddenConfirmPassword,
            // type: TextInputType.te,
            action: TextInputAction.next,
            suffix: InkWell(
              onTap: () => setState(
                  () => hiddenConfirmPassword = !hiddenConfirmPassword),
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  hiddenConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: SECONDARY_COLOR
                      .withOpacity(hiddenConfirmPassword ? 0.5 : 1.0),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.white,
            thickness: 1.2,
            height: 20,
          ),
          CustomTextFormField(
            'Username',
            controller: authController.usernameController.value,
            type: TextInputType.name,
          ),
          CustomDropdownField(
            gender,
            "Gender",
            onChanged: (val) {
              authController.gender.value = val!;
            },
          ),
          CustomTextFormField(
            'Description',
            controller: authController.descController.value,
            type: TextInputType.multiline,
            maxLines: 10,
          ),
          Divider(
            color: Colors.white,
            thickness: 1.2,
            height: 20,
          ),
          CustomTextFormField(
            'Phone',
            controller: authController.phoneController.value,
            type: TextInputType.phone,
          ),
          CustomTextFormField(
            'Address',
            controller: authController.addressController.value,
            type: TextInputType.multiline,
            maxLines: 10,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    authController.loading.value = false;
    super.dispose();
  }
}
