import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio _dio;

  MovieRemoteDataSource(TmdbDioClient client) : _dio = client.dio;

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await _dio.get('/movie/popular');
      final results = response.data['results'] as List;
      return results
          .map((m) => MovieModel.fromJson(m as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw Exception('Failed to fetch movies: ${e.message}');
    }
  }
}
