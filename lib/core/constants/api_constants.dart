import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // TMDB
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static String get tmdbBearerToken => dotenv.env['TMDB_BEARER_TOKEN'] ?? '';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';
  static const String backdropBaseUrl = 'https://image.tmdb.org/t/p/w780';

  // DummyJSON — separate base URL for review CRUD
  static const String dummyJsonBaseUrl = 'https://dummyjson.com';
}
