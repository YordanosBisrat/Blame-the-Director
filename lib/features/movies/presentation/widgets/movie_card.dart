import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';

class MovieCard extends StatefulWidget {
  final MovieModel movie;

  final VoidCallback onAddReview;

  const MovieCard({super.key, required this.movie, required this.onAddReview});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      decoration: BoxDecoration(
        color: Colors.black87,

        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 10),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),

            child: Stack(
              children: [
                Image.network(
                  widget.movie.fullPosterPath,

                  height: 250,

                  width: double.infinity,

                  fit: BoxFit.cover,
                ),

                Positioned(
                  top: 12,
                  right: 12,

                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },

                    child: CircleAvatar(
                      backgroundColor: Colors.black54,

                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,

                        color: isFavorite ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  widget.movie.title,

                  style: const TextStyle(
                    color: Colors.white,

                    fontSize: 20,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),

                    const SizedBox(width: 5),

                    Text(
                      widget.movie.voteAverage.toStringAsFixed(1),

                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  widget.movie.overview,

                  maxLines: 3,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(color: Colors.white70, height: 1.5),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: widget.onAddReview,

                    icon: const Icon(Icons.reviews),

                    label: const Text('Add Review'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
