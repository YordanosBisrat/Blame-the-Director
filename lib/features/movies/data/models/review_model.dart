import 'dart:convert';

class ReviewModel {
  final int id; // DummyJSON post id
  final int movieId; // TMDB movie id
  final String movieTitle;
  final String reviewText;
  final int rating; // 1–5

  const ReviewModel({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.reviewText,
    required this.rating,
  });

  /// DummyJSON stores everything in the `body` field as a JSON string.
  /// Shape: {"movieId":550,"movieTitle":"Fight Club","reviewText":"...","rating":4}
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    final rawBody = json['body'] as String? ?? '';

    Map<String, dynamic> parsed = {};
    try {
      parsed = jsonDecode(rawBody) as Map<String, dynamic>;
    } catch (_) {
      // Legacy plain-text body — treat as reviewText only
      parsed = {'reviewText': rawBody};
    }

    return ReviewModel(
      id: json['id'] as int,
      movieId: parsed['movieId'] as int? ?? 0,
      movieTitle: parsed['movieTitle'] as String? ?? '',
      reviewText: parsed['reviewText'] as String? ?? rawBody,
      rating: parsed['rating'] as int? ?? 3,
    );
  }

  /// Serialise rich data into the DummyJSON body field.
  Map<String, dynamic> toPostBody() {
    final encodedBody = jsonEncode({
      'movieId': movieId,
      'movieTitle': movieTitle,
      'reviewText': reviewText,
      'rating': rating,
    });
    return {'title': 'Review: $movieTitle', 'body': encodedBody, 'userId': 1};
  }

  /// For PUT requests — only update mutable fields.
  Map<String, dynamic> toUpdateBody() {
    final encodedBody = jsonEncode({
      'movieId': movieId,
      'movieTitle': movieTitle,
      'reviewText': reviewText,
      'rating': rating,
    });
    return {'body': encodedBody};
  }

  ReviewModel copyWith({
    int? id,
    int? movieId,
    String? movieTitle,
    String? reviewText,
    int? rating,
  }) {
    return ReviewModel(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      reviewText: reviewText ?? this.reviewText,
      rating: rating ?? this.rating,
    );
  }
}
