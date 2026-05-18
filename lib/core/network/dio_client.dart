import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/api_constants.dart';

/// Singleton Dio instance for TMDB (movies, images, metadata).
class TmdbDioClient {
  TmdbDioClient._();
  static final TmdbDioClient _instance = TmdbDioClient._();
  factory TmdbDioClient() => _instance;

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.tmdbBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Authorization': 'Bearer ${ApiConstants.tmdbBearerToken}',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: false,
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => debugPrint('[TMDB] $obj'),
          ),
        );
}

/// Singleton Dio instance for DummyJSON (review CRUD operations).
class DummyJsonDioClient {
  DummyJsonDioClient._();
  static final DummyJsonDioClient _instance = DummyJsonDioClient._();
  factory DummyJsonDioClient() => _instance;

  late final Dio dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstants.dummyJsonBaseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: false,
            requestBody: true,
            responseBody: true,
            logPrint: (obj) => debugPrint('[DummyJSON] $obj'),
          ),
        );
}
