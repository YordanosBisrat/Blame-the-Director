import 'package:flutter/material.dart';

import '../../data/datasources/movie_remote_data_source.dart';
import '../../data/datasources/review_remote_data_source.dart';

import '../../data/models/movie_model.dart';

import '../widgets/movie_card.dart';
import '../widgets/add_review_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MovieRemoteDataSource remoteDataSource = MovieRemoteDataSource();

  List<MovieModel> movies = [];

  bool isLoading = true;

  Map<int, List<String>> reviews = {};

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    try {
      final result = await remoteDataSource.getPopularMovies();

      setState(() {
        movies = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      debugPrint(e.toString());
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blame the Director')),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
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
                      ...reviews[movie.id]!.map(
                        (review) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),

                          child: Align(
                            alignment: Alignment.centerLeft,

                            child: Text(
                              '📝 $review',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
    );
  }
}
