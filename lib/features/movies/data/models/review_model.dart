class ReviewModel {
  final int id;
  final String body;

  ReviewModel({required this.id, required this.body});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(id: json['id'], body: json['body'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'body': body};
  }
}
