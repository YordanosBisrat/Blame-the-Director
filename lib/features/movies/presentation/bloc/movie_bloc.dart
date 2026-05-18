import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasources/movie_remote_data_source.dart';

import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRemoteDataSource remoteDataSource;

  MovieBloc(this.remoteDataSource) : super(MovieInitial()) {
    on<FetchMoviesEvent>((event, emit) async {
      emit(MovieLoading());

      try {
        final movies = await remoteDataSource.getPopularMovies();

        emit(MovieLoaded(movies));
      } catch (e) {
        emit(MovieError(e.toString()));
      }
    });
  }
}
