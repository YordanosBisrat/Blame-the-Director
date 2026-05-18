import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/movie_model.dart';
import '../../data/models/review_model.dart';
import '../bloc/movie_bloc/movie_bloc.dart';
import '../bloc/movie_bloc/movie_event.dart';
import '../bloc/movie_bloc/movie_state.dart';
import '../bloc/review_bloc/review_bloc.dart';
import '../bloc/review_bloc/review_event.dart';
import '../bloc/review_bloc/review_state.dart';
import '../widgets/add_review_dialog.dart';
import '../widgets/edit_review_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/movie_card.dart' show MovieCard;
import '../widgets/review_card.dart' show ReviewCard;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentTab = 0;

  void _showAddReviewDialog(BuildContext context, MovieModel movie) {
    showDialog(
      context: context,
      builder: (_) => AddReviewDialog(
        movie: movie,
        onSubmit: (review) =>
            context.read<ReviewBloc>().add(AddReviewEvent(review)),
      ),
    );
  }

  void _showEditReviewDialog(BuildContext context, ReviewModel review) {
    showDialog(
      context: context,
      builder: (_) => EditReviewDialog(
        review: review,
        onSubmit: (updated) =>
            context.read<ReviewBloc>().add(UpdateReviewEvent(updated)),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ReviewModel review) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete verdict?'),
        content: Text(
          'Remove your review of "${review.movieTitle}"? The director will not be notified.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ReviewBloc>().add(DeleteReviewEvent(review.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE50914),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: context.read<MovieBloc>()),
        BlocProvider(create: (_) => sl<ReviewBloc>()..add(FetchReviewsEvent())),
      ],
      child: BlocListener<ReviewBloc, ReviewState>(
        listener: (context, state) {
          if (state is ReviewOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is ReviewError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: const Color(0xFFE50914),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Blame ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: 'the Director',
                    style: TextStyle(
                      color: Color(0xFFE50914),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Row(
                children: [
                  _TabButton(
                    label: 'Movies',
                    index: 0,
                    current: _currentTab,
                    onTap: (i) => setState(() => _currentTab = i),
                  ),
                  _TabButton(
                    label: 'My Verdicts',
                    index: 1,
                    current: _currentTab,
                    onTap: (i) => setState(() => _currentTab = i),
                  ),
                ],
              ),
            ),
          ),
          body: _currentTab == 0
              ? _MoviesTab(onAddReview: _showAddReviewDialog)
              : _VerdictsTab(
                  onEdit: _showEditReviewDialog,
                  onDelete: _confirmDelete,
                ),
        ),
      ),
    );
  }
}

// ─── Tab button ───────────────────────────────────────────────────────────────

class _TabButton extends StatelessWidget {
  final String label;
  final int index;
  final int current;
  final void Function(int) onTap;

  const _TabButton({
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFFE50914) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.white38,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

// ─── Movies tab ───────────────────────────────────────────────────────────────

class _MoviesTab extends StatefulWidget {
  final void Function(BuildContext, MovieModel) onAddReview;

  const _MoviesTab({required this.onAddReview});

  @override
  State<_MoviesTab> createState() => _MoviesTabState();
}

class _MoviesTabState extends State<_MoviesTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieBloc, MovieState>(
      builder: (context, state) {
        if (state is MovieLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        if (state is MovieError) {
          return EmptyStateWidget(
            icon: Icons.wifi_off_rounded,
            title: "Couldn't reach the studio",
            subtitle: state.message,
            actionLabel: 'Try again',
            onAction: () => context.read<MovieBloc>().add(FetchMoviesEvent()),
          );
        }

        if (state is MovieLoaded) {
          final filtered = state.movies
              .where(
                (m) =>
                    m.title.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search films to blame...',
                    prefixIcon: Icon(Icons.search, color: Colors.white38),
                  ),
                ),
              ),
              Expanded(
                child: filtered.isEmpty
                    ? const EmptyStateWidget(
                        icon: Icons.search_off,
                        title: 'No films found',
                        subtitle:
                            'The director probably escaped to another franchise.',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 24),
                        itemCount: filtered.length,
                        itemBuilder: (ctx, i) {
                          final movie = filtered[i];
                          return MovieCard(
                            movie: movie,
                            onAddReview: () =>
                                widget.onAddReview(context, movie),
                          );
                        },
                      ),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}

// ─── Verdicts tab ─────────────────────────────────────────────────────────────

class _VerdictsTab extends StatelessWidget {
  final void Function(BuildContext, ReviewModel) onEdit;
  final void Function(BuildContext, ReviewModel) onDelete;

  const _VerdictsTab({required this.onEdit, required this.onDelete});

  List<ReviewModel> _reviewsFromState(ReviewState state) {
    if (state is ReviewsLoaded) return state.reviews;
    if (state is ReviewOperationSuccess) return state.reviews;
    if (state is ReviewError) return state.previousReviews;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewBloc, ReviewState>(
      builder: (context, state) {
        if (state is ReviewLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE50914)),
          );
        }

        final reviews = _reviewsFromState(state);

        if (reviews.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.gavel,
            title: 'No verdicts yet',
            subtitle:
                'Go to Movies and file your first complaint.\nThe directors are waiting.',
          );
        }

        return RefreshIndicator(
          color: const Color(0xFFE50914),
          onRefresh: () async =>
              context.read<ReviewBloc>().add(FetchReviewsEvent()),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 12),
            itemCount: reviews.length,
            itemBuilder: (ctx, i) {
              final review = reviews[i];
              return ReviewCard(
                review: review,
                onEdit: () => onEdit(context, review),
                onDelete: () => onDelete(context, review),
              );
            },
          ),
        );
      },
    );
  }
}
