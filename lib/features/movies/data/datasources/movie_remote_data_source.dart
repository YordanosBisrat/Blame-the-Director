import 'package:dio/dio.dart';

import '../../../../core/network/dio_client.dart';
import '../models/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio = DioClient().dio;

  Future<List<MovieModel>> getPopularMovies() async {
    try {
      final response = await dio.get('/movie/popular');

      final results = response.data['results'] as List;

      return results.map((movie) => MovieModel.fromJson(movie)).toList();
    } catch (e) {
      throw Exception('Failed to fetch movies');
    }
  }
}
