import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

import '../pages/movie_details_page.dart';

class MovieCard extends StatelessWidget {
  final MovieModel movie;

  final VoidCallback onAddReview;

  const MovieCard({super.key, required this.movie, required this.onAddReview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MovieDetailsPage(movie: movie)),
        );
      },

      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

        decoration: BoxDecoration(
          color: Colors.white10,

          borderRadius: BorderRadius.circular(16),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),

              child: Image.network(
                movie.fullPosterPath,

                height: 250,

                width: double.infinity,

                fit: BoxFit.cover,

                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return Container(
                    height: 250,

                    alignment: Alignment.center,

                    child: const CircularProgressIndicator(),
                  );
                },

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,

                    color: Colors.grey.shade900,

                    alignment: Alignment.center,

                    child: const Icon(
                      Icons.broken_image,

                      color: Colors.white54,

                      size: 50,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    movie.title,

                    style: const TextStyle(
                      color: Colors.white,

                      fontSize: 20,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),

                      const SizedBox(width: 4),

                      Text(
                        movie.voteAverage.toString(),

                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    movie.overview,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(color: Colors.white70, height: 1.5),
                  ),

                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: onAddReview,

                      icon: const Icon(Icons.rate_review),

                      label: const Text('Add Review'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
