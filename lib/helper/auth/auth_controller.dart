import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:make_up/component/const.dart';
import 'package:make_up/page/auth/login.dart';
import 'package:make_up/page/root.dart';

class AuthController extends GetxController {
  GetStorage authStorage = GetStorage('authStorage');

  var emailController = new TextEditingController().obs;
  var phoneController = new TextEditingController().obs;
  var addressController = new TextEditingController().obs;
  var usernameController = new TextEditingController().obs;
  var descController = new TextEditingController().obs;
  var passwordController = new TextEditingController().obs;
  var confirmPasswordController = new TextEditingController().obs;

  RxString gender = "".obs;

  RxBool isLogin = false.obs;
  RxBool loading = false.obs;

  @override
  void onInit() {
    checkAuth();
    super.onInit();
  }

  checkAuth() {
    if (authStorage.read('isLogin') == null || !authStorage.read('isLogin')) {
      isLogin.value = false;
      authStorage.write('isLogin', false);
    } else {
      isLogin.value = true;
      authStorage.write('isLogin', true);
    }
  }

  Future login() async {
    try {
      String? message;
      Color? color;

      var resp = await http.post(Uri.parse('$URL/login'), body: {
        'email': emailController.value.text,
        'password': passwordController.value.text,
      }, headers: {
        'Accept': 'application/json'
      });

      if (resp.statusCode == 200) {
        message = "Berhasil login";
        color = Colors.blue;

        var data = json.decode(resp.body)['data'];

        authStorage.write('user', data);
        authStorage.write('isLogin', true);

        isLogin.value = true;

        showMessage(message, color);

        cleanData();

        await Future.delayed(
          Duration(milliseconds: 800),
          () => Get.offAll(Root()),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  register() async {
    String? message;
    Color? color;

    try {
      var resp = await http.post(Uri.parse('$URL/register'), body: {
        'email': emailController.value.text,
        'name': usernameController.value.text,
        'password': passwordController.value.text,
        'phone': phoneController.value.text,
        'gender': gender.value,
        'address': addressController.value.text,
        'desc': descController.value.text,
        'level': 'client',
        'status_id': '2',
        'image': 'avatar.png',
      }, headers: {
        'Accept': 'application/json',
      });

      if (resp.statusCode == 200) {
        color = Colors.blue;
        message = "Registrasi berhasil";
        showMessage(message, color);

        await Future.delayed(
          Duration(milliseconds: 800),
          () => Get.off(
            LoginPage(),
            transition: Transition.downToUp,
            duration: Duration(milliseconds: 500),
          ),
        );
      } else {
        color = Color(0xffa82719);
        message = "Registrasi gagal !";
      }
    } catch (e) {
      print(e);
    }
  }

  showMessage(String message, Color color) {
    loading.value = false;

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      fontSize: 16.0,
    );
  }

  logOut() {
    authStorage.write('isLogin', false);
    authStorage.remove('user');
    isLogin.value = false;
  }

  cleanData() {
    emailController.value.clear();
    passwordController.value.clear();
    confirmPasswordController.value.clear();
    usernameController.value.clear();
    phoneController.value.clear();
    addressController.value.clear();
    descController.value.clear();
    gender = "".obs;
  }

  @override
  void dispose() {
    cleanData();
    loading.value = false;
    super.dispose();
  }
}
