import 'package:flutter/material.dart';
import '../widgets/movie_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blame the Director')),

      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MoviesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MoviesLoaded) {
            return ListView.builder(
              itemCount: state.movies.length,

              itemBuilder: (context, index) {
                final movie = state.movies[index];

                return MovieCard(movie: movie);
              },
            );
          }

          if (state is MoviesError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }
}
