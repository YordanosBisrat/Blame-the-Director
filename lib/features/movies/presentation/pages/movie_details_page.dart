import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/movie_model.dart';
import '../../data/models/review_model.dart';
import '../bloc/review_bloc/review_bloc.dart';
import '../bloc/review_bloc/review_event.dart';
import '../widgets/add_review_dialog.dart';

class MovieDetailsPage extends StatelessWidget {
  final MovieModel movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: CustomScrollView(
        slivers: [
          // ── Hero backdrop ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: const Color(0xFF0D0D0D),
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              title: Text(
                movie.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, blurRadius: 8)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: movie.fullBackdropPath.isNotEmpty
                        ? movie.fullBackdropPath
                        : movie.fullPosterPath,
                    fit: BoxFit.cover,
                    placeholder: (_, _) =>
                        Container(color: const Color(0xFF1A1A1A)),
                    errorWidget: (_, _, _) => Container(
                      color: const Color(0xFF1A1A1A),
                      child: const Icon(
                        Icons.movie,
                        color: Colors.white24,
                        size: 64,
                      ),
                    ),
                  ),
                  // Gradient overlay so title is readable
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC000000)],
                        stops: [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ────────────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Meta row: year · rating
                  Row(
                    children: [
                      if (movie.releaseYear.isNotEmpty) ...[
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: Colors.white38,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          movie.releaseYear,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        movie.voteAverage.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' / 10',
                        style: TextStyle(color: Colors.white38, fontSize: 12),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Overview
                  const Text(
                    'Overview',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    movie.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showAddReview(context),
                      icon: const Icon(Icons.gavel, size: 20),
                      label: const Text('Blame the Director'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

  void _showAddReview(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AddReviewDialog(
        movie: movie,
        onSubmit: (ReviewModel review) =>
            context.read<ReviewBloc>().add(AddReviewEvent(review)),
      ),
    );
  }
}
