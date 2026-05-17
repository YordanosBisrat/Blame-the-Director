import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/movie_remote_data_source.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRemoteDataSource remoteDataSource;

  MovieBloc(this.remoteDataSource) : super(MovieInitial()) {
    on<LoadMovies>(_onLoadMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MoviesLoading());

    try {
      final movies = await remoteDataSource.getPopularMovies();

      emit(MoviesLoaded(movies));
    } catch (e) {
      emit(const MoviesError('Failed to fetch movies'));
    }
  }
}
