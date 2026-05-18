import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

class MovieDetailsPage extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,

            pinned: true,

            backgroundColor: Colors.black,

            flexibleSpace: FlexibleSpaceBar(
              title: Text(movie.title),

              background: Image.network(
                movie.fullPosterPath,

                fit: BoxFit.cover,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    color: Colors.black,

                    alignment: Alignment.center,

                    child: const CircularProgressIndicator(),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,

                    alignment: Alignment.center,

                    child: const Icon(
                      Icons.broken_image,

                      color: Colors.white54,

                      size: 60,
                    ),
                  );
                },
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),

                      const SizedBox(width: 6),

                      Text(
                        movie.voteAverage.toString(),

                        style: const TextStyle(
                          color: Colors.white,

                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Overview',

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 22,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    movie.overview,

                    style: const TextStyle(
                      color: Colors.white70,

                      fontSize: 16,

                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
