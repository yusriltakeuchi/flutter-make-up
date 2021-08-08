import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:make_up/component/const.dart';
import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/transaction_model.dart';
import 'package:make_up/model/user_model.dart';
import 'package:make_up/page/root.dart';

class ApiController extends GetxController {
  var commentController = TextEditingController().obs;
  var searchController = TextEditingController().obs;

  var phoneController = TextEditingController().obs;
  var peopleController = TextEditingController().obs;
  var dateController = TextEditingController().obs;
  var startController = TextEditingController().obs;
  var endController = TextEditingController().obs;
  var addressController = TextEditingController().obs;

  RxList<dynamic> listCategory = <String>[].obs;
  RxList<String> listUsername = <String>[].obs;
  RxBool loading = false.obs;

  RxList<Transaction> listUpComing = <Transaction>[].obs;
  RxList<Transaction> listHistory = <Transaction>[].obs;

  Future getRecentTransaction(String id) async {
    listUpComing.value = [];
    listHistory.value = [];
    await getUserDetail(id).then((data) {
      data.transaction!.map((e) {
        if (e.status == "disapproved") {
          listUpComing.add(e);
        } else {
          listHistory.add(e);
        }
      });
      update();
    });
  }

  Future<List<dynamic>> getListCategory() async {
    try {
      var resp = await http.post(Uri.parse("$URL/category"),
          headers: {'Accept': 'application/json'});

      if (resp.statusCode == 200) {
        return json.decode(resp.body);
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<JobModel>> listJobs() async {
    try {
      var resp = await http.post(Uri.parse("$URL/jobs"),
          headers: {'Accept': 'application/json'});

      if (resp.statusCode == 200) {
        List data = json.decode(resp.body)['data'];
        return data.map((e) => JobModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
      return [];
    }
    return [];
  }

  Future<UserModel> getUserDetail(String id) async {
    try {
      var resp = await http.get(
        Uri.parse("$URL/user/$id"),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        Map<String, dynamic> data = json.decode(resp.body);
        UserModel user = UserModel.fromJson(data);
        return user;
      } else {
        return Future.value();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      var resp = await http.get(
        Uri.parse("$URL/users"),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        List data = json.decode(resp.body);
        return data.map((e) => UserModel.fromJson(e)).toList();
      } else {
        return Future.value();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<JobModel> getJob(String id) async {
    try {
      var resp = await http.get(
        Uri.parse("$URL/job/$id"),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        Map<String, dynamic> data = json.decode(resp.body);
        JobModel job = JobModel.fromJson(data);
        return job;
      } else {
        return Future.value();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future storeComment(int userId, jobsId, star) async {
    try {
      var resp = await http.post(
        Uri.parse('$URL/comment'),
        body: {
          'user_id': userId.toString(),
          'jasa_id': jobsId.toString(),
          'comment': commentController.value.text,
          'star': star.toString()
        },
        headers: {'Accept': 'application/json'},
      );

      if (resp.statusCode == 200) {
        commentController.value.clear();
        showMessage('Komentar berhasil dikirim', Colors.blue);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<Transaction> getOrder(String id) async {
    try {
      var resp = await http.get(
        Uri.parse("$URL/order/$id"),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        Map<String, dynamic> data = json.decode(resp.body);
        Transaction trans = Transaction.fromJson(data);
        return trans;
      } else {
        return Future.value();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future storeOrder(int userId, jobsId) async {
    try {
      var resp = await http.post(
        Uri.parse('$URL/order'),
        body: {
          'user_id': userId.toString(),
          'jasa_id': jobsId.toString(),
          'total_people': peopleController.value.text,
          'address': addressController.value.text,
          'phone': phoneController.value.text,
          'status': 'disapproved',
          'booking_date': dateController.value.text,
          'booking_start': startController.value.text,
          'booking_end': endController.value.text,
        },
        headers: {'Accept': 'application/json'},
      );

      if (resp.statusCode == 200) {
        peopleController.value.clear();
        dateController.value.clear();
        addressController.value.clear();
        phoneController.value.clear();
        startController.value.clear();
        endController.value.clear();

        showMessage('Transaction in progress', Colors.orange);
        return Get.offAll(Root());
        // return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      var resp = await http.delete(Uri.parse("$URL/order/$id"),
          headers: {'Accept': 'application/json'});

      if (resp.statusCode == 200) {
        showMessage('Transaksi berhasil diperbarui', Colors.blue);
        return Future.value();
      } else {
        showMessage('Gagal memperbarui data', SECONDARY_COLOR);
        return Future.value();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  showMessage(String message, Color color) {
    loading.value = false;
    EasyLoading.dismiss();

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      fontSize: 16.0,
    );
  }
}
