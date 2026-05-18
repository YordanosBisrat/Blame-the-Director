import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  final VoidCallback onAddReview;

  const MovieCard({super.key, required this.movie, required this.onAddReview});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.black87,

        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

            child: Image.network(
              movie.fullPosterPath,

              height: 300,

              width: double.infinity,

              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  movie.title,

                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  movie.overview,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),

                const SizedBox(height: 14),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),

                        const SizedBox(width: 5),

                        Text(
                          movie.voteAverage.toString(),

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),

                    TextButton.icon(
                      onPressed: onAddReview,

                      icon: const Icon(Icons.rate_review, color: Colors.red),

                      label: const Text(
                        'Add Review',

                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
