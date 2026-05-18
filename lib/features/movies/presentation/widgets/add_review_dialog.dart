import 'package:flutter/material.dart';

import '../../../movies/data/models/movie_model.dart';
import '../../../movies/data/models/review_model.dart';

class AddReviewDialog extends StatefulWidget {
  final MovieModel movie;
  final void Function(ReviewModel) onSubmit;

  const AddReviewDialog({
    super.key,
    required this.movie,
    required this.onSubmit,
  });

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final TextEditingController _controller = TextEditingController();
  int _rating = 3;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSubmit(
      ReviewModel(
        id: 0, // DummyJSON assigns the real id
        movieId: widget.movie.id,
        movieTitle: widget.movie.title,
        reviewText: text,
        rating: _rating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('File your verdict'),
          const SizedBox(height: 2),
          Text(
            widget.movie.title,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFFE50914),
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Star rating picker
            const Text(
              'Your rating',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 6),
            Row(
              children: List.generate(5, (i) {
                return GestureDetector(
                  onTap: () => setState(() => _rating = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Icon(
                      i < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 30,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: 4,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "Why is it the director's fault?",
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Blame them')),
      ],
    );
  }
}
