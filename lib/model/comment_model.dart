class Comment {
  int? id, userId, star;
  String? author, imageAuthor, content, createdAt;

  Comment({
    this.id,
    this.userId,
    this.star,
    this.author,
    this.imageAuthor,
    this.content,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'],
        userId: json['user_id'],
        star: json['star'],
        author: json['author'],
        imageAuthor: json['image_author'],
        content: json['content'],
        createdAt: json['created_at'],
      );
}
