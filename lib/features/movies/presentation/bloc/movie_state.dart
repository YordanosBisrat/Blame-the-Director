import 'package:equatable/equatable.dart';

import '../../data/models/movie_model.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieInitial extends MovieState {}

class MoviesLoading extends MovieState {}

class MoviesLoaded extends MovieState {
  final List<MovieModel> movies;

  const MoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class MoviesError extends MovieState {
  final String message;

  const MoviesError(this.message);

  @override
  List<Object> get props => [message];
}
