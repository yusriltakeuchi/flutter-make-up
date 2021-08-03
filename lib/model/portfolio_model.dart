class Portfolio {
  int? id;
  String? image, createdAt, description;

  Portfolio({
    this.id,
    this.image,
    this.createdAt,
    this.description,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
      id: json['id'],
      image: json['image'],
      createdAt: json['created_at'],
      description: json['description']);
}
