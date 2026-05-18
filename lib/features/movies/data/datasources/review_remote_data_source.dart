import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/review_model.dart';

class ReviewRemoteDataSource {
  final Dio _dio;

  ReviewRemoteDataSource(DummyJsonDioClient client) : _dio = client.dio;

  /// CREATE — POST /posts/add
  Future<ReviewModel> addReview(ReviewModel review) async {
    try {
      final response = await _dio.post('/posts/add', data: review.toPostBody());
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to add review: ${e.message}');
    }
  }

  /// READ — GET /posts (fetch all reviews for this user)
  Future<List<ReviewModel>> fetchReviews() async {
    try {
      final response = await _dio.get('/posts', queryParameters: {'limit': 30});
      final posts = response.data['posts'] as List;
      return posts
          .map((p) => ReviewModel.fromJson(p as Map<String, dynamic>))
          .where((r) => r.movieId != 0) // only our app's reviews
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch reviews: ${e.message}');
    }
  }

  /// UPDATE — PUT /posts/{id}
  Future<ReviewModel> updateReview(ReviewModel review) async {
    try {
      final response = await _dio.put(
        '/posts/${review.id}',
        data: review.toUpdateBody(),
      );
      return ReviewModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw Exception('Failed to update review: ${e.message}');
    }
  }

  /// DELETE — DELETE /posts/{id}
  Future<void> deleteReview(int reviewId) async {
    try {
      await _dio.delete('/posts/$reviewId');
    } on DioException catch (e) {
      throw Exception('Failed to delete review: ${e.message}');
    }
  }
}
