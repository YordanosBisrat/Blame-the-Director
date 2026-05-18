import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'features/movies/presentation/bloc/movie_bloc/movie_bloc.dart';
import 'features/movies/presentation/bloc/movie_bloc/movie_event.dart';
import 'features/movies/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  setupServiceLocator();
  runApp(const BlameTheDirectorApp());
}

class BlameTheDirectorApp extends StatelessWidget {
  const BlameTheDirectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MovieBloc>()..add(FetchMoviesEvent()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Blame the Director',
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
