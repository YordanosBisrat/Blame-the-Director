import 'package:flutter/material.dart';

import '../../data/models/movie_model.dart';
import '../../data/datasources/review_remote_data_source.dart';
import 'add_review_dialog.dart';

class MovieCard extends StatefulWidget {
  final MovieModel movie;

  const MovieCard({super.key, required this.movie});

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  String? reviewText;
  final ReviewRemoteDataSource reviewRemoteDataSource =
      ReviewRemoteDataSource();

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Card(
      margin: const EdgeInsets.all(12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),

            child: Image.network(
              movie.fullPosterPath,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  movie.overview,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 12),
                if (reviewText != null) ...[
                  Text(
                    'Your Review:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Text(reviewText!),

                  const SizedBox(height: 12),
                ],

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber),

                        const SizedBox(width: 4),

                        Text(movie.voteAverage.toStringAsFixed(1)),
                      ],
                    ),

                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,

                          builder: (_) {
                            return AddReviewDialog(
                              onSubmit: (reviewText) async {
                                try {
                                  await reviewRemoteDataSource.addReview(
                                    reviewText,
                                  );
                                  setState(() {
                                    this.reviewText = reviewText;
                                  });

                                  if (!context.mounted) {
                                    return;
                                  }

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Review added successfully',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to add review'),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },

                      icon: const Icon(Icons.add_comment),

                      label: const Text('Add Review'),
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
