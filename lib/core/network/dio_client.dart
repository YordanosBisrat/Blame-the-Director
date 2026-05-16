import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: 'https://api.themoviedb.org/3',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
          ),
        );
}
