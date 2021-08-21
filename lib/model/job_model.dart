import 'package:make_up/model/comment_model.dart';

import 'category_model.dart';

class JobModel {
  int? id, userId;
  String? name, price, city, rating, start, end, status, desc, image, createdAt;
  Category? category;
  List<Comment>? comment;

  JobModel({
    this.id,
    this.userId,
    this.name,
    this.price,
    this.city,
    this.start,
    this.end,
    this.rating,
    this.status,
    this.desc,
    this.image,
    this.createdAt,
    this.category,
    this.comment,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        id: json['id'],
        userId: json['user_id'],
        name: json['name'],
        price: json['price'],
        status: json['status'],
        city: json['city'],
        rating: json['rating'],
        start: json['start'],
        end: json['end'],
        desc: json['desc'],
        image: json['image'],
        createdAt: json['created_at'],
        category: json['category'] == null
            ? null
            : Category.fromJson(json['category']),
        comment: json['comment'] == null
            ? null
            : List<Comment>.from(
                json['comment'].map(
                  (e) => Comment.fromJson(e),
                ),
              ),
      );
}
