import 'package:get_it/get_it.dart';

import '../network/dio_client.dart';
import '../../features/movies/data/datasources/movie_remote_data_source.dart';
import '../../features/movies/data/datasources/review_remote_data_source.dart';
import '../../features/movies/presentation/bloc/movie_bloc/movie_bloc.dart';
import '../../features/movies/presentation/bloc/review_bloc/review_bloc.dart';

final GetIt sl = GetIt.instance;

void setupServiceLocator() {
  // Dio clients — singletons
  sl.registerLazySingleton<TmdbDioClient>(() => TmdbDioClient());
  sl.registerLazySingleton<DummyJsonDioClient>(() => DummyJsonDioClient());

  // Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSource(sl<TmdbDioClient>()),
  );
  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSource(sl<DummyJsonDioClient>()),
  );

  // BLoCs — factory so each BlocProvider gets a fresh instance
  sl.registerFactory<MovieBloc>(() => MovieBloc(sl<MovieRemoteDataSource>()));
  sl.registerFactory<ReviewBloc>(
    () => ReviewBloc(sl<ReviewRemoteDataSource>()),
  );
}
