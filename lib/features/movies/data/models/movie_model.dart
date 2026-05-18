import '../../../../core/constants/api_constants.dart';

class MovieModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double voteAverage;
  final String releaseDate;

  const MovieModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String? ?? '',
      posterPath: json['poster_path'] as String? ?? '',
      backdropPath: json['backdrop_path'] as String? ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] as String? ?? '',
    );
  }

  String get fullPosterPath =>
      posterPath.isNotEmpty ? '${ApiConstants.imageBaseUrl}$posterPath' : '';

  String get fullBackdropPath => backdropPath.isNotEmpty
      ? '${ApiConstants.backdropBaseUrl}$backdropPath'
      : '';

  /// e.g. "2024"
  String get releaseYear =>
      releaseDate.length >= 4 ? releaseDate.substring(0, 4) : '';
}
