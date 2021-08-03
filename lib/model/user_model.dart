import 'package:make_up/model/job_model.dart';
import 'package:make_up/model/portfolio_model.dart';
import 'package:make_up/model/transaction_model.dart';

class UserModel {
  int? id;
  String? name, image, email, gender, phone, address, desc, status, createdAt;
  List<JobModel>? jobs;
  List<Portfolio>? portfolio;
  List<Transaction>? transaction;

  UserModel({
    this.id,
    this.name,
    this.image,
    this.email,
    this.gender,
    this.address,
    this.desc,
    this.phone,
    this.status,
    this.createdAt,
    this.jobs,
    this.portfolio,
    this.transaction,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        name: json['name'],
        image: json['image'],
        email: json['email'],
        phone: json['phone'],
        gender: json['gender'],
        address: json['address'],
        desc: json['desc'],
        status: json['status'],
        createdAt: json['created_at'],
        jobs: json['jobs'] == null
            ? []
            : List<JobModel>.from(
                json['jobs'].map((e) => JobModel.fromJson(e))),
        portfolio: json['portfolio'] == null
            ? []
            : List<Portfolio>.from(
                json['portfolio'].map((e) => Portfolio.fromJson(e))),
        transaction: json['transactions'] == null
            ? []
            : List<Transaction>.from(
                json['transactions'].map((e) => Transaction.fromJson(e))),
      );
}
