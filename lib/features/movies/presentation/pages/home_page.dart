import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/movie_bloc.dart';
import '../bloc/movie_state.dart';

import '../../data/datasources/review_remote_data_source.dart';

import '../widgets/movie_card.dart';
import '../widgets/add_review_dialog.dart';
import '../widgets/edit_review_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<int, List<String>> reviews = {};

  Future<void> addReview(int movieId, String reviewText) async {
    try {
      final reviewRemoteDataSource = ReviewRemoteDataSource();

      await reviewRemoteDataSource.addReview(reviewText);

      setState(() {
        reviews.putIfAbsent(movieId, () => []);

        reviews[movieId]!.add(reviewText);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review Added')));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void updateReview(int movieId, int reviewIndex, String newReview) {
    setState(() {
      reviews[movieId]![reviewIndex] = newReview;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review Updated')));
  }

  void deleteReview(int movieId, int reviewIndex) {
    setState(() {
      reviews[movieId]!.removeAt(reviewIndex);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Review Deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blame the Director')),

      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovieError) {
            return Center(child: Text(state.message));
          }

          if (state is MovieLoaded) {
            final movies = state.movies;

            return ListView.builder(
              itemCount: movies.length,

              itemBuilder: (context, index) {
                final movie = movies[index];

                return Column(
                  children: [
                    MovieCard(
                      movie: movie,

                      onAddReview: () {
                        showDialog(
                          context: context,

                          builder: (_) {
                            return AddReviewDialog(
                              onSubmit: (text) {
                                addReview(movie.id, text);
                              },
                            );
                          },
                        );
                      },
                    ),

                    if (reviews[movie.id] != null)
                      ...reviews[movie.id]!.asMap().entries.map((entry) {
                        final reviewIndex = entry.key;

                        final review = entry.value;

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),

                          child: Container(
                            padding: const EdgeInsets.all(12),

                            decoration: BoxDecoration(
                              color: Colors.white10,

                              borderRadius: BorderRadius.circular(12),
                            ),

                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,

                              children: [
                                Expanded(
                                  child: Text(
                                    '📝 $review',

                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,

                                      builder: (_) {
                                        return EditReviewDialog(
                                          initialText: review,

                                          onSubmit: (newText) {
                                            updateReview(
                                              movie.id,
                                              reviewIndex,
                                              newText,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  },

                                  icon: const Icon(
                                    Icons.edit,

                                    color: Colors.amber,
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    deleteReview(movie.id, reviewIndex);
                                  },

                                  icon: const Icon(
                                    Icons.delete,

                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                    const SizedBox(height: 10),
                  ],
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
