import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/review_model.dart';

class ReviewRemoteDataSource {
  final Dio dio = DioClient().dio;

  Future<ReviewModel> addReview(String reviewText) async {
    try {
      final response = await dio.post(
        'https://dummyjson.com/posts/add',
        data: {'title': 'Movie Review', 'body': reviewText, 'userId': 1},
      );

      return ReviewModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to add review');
    }
  }

  Future<ReviewModel> updateReview(int reviewId, String reviewText) async {
    try {
      final response = await dio.put(
        'https://dummyjson.com/posts/$reviewId',
        data: {'body': reviewText},
      );

      return ReviewModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update review');
    }
  }
}
