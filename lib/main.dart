import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/movies/presentation/pages/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/network/dio_client.dart';
import 'features/movies/data/datasources/movie_remote_data_source.dart';
import 'features/movies/presentation/bloc/movie_bloc.dart';
import 'features/movies/presentation/bloc/movie_event.dart';

void main() {
  runApp(const BlameTheDirectorApp());
}

class BlameTheDirectorApp extends StatelessWidget {
  const BlameTheDirectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blame the Director',
      theme: AppTheme.darkTheme,
      home: BlocProvider(
        create: (_) => MovieBloc(MovieRemoteDataSource())..add(LoadMovies()),
        child: const HomePage(),
      ),
    );
  }
}
