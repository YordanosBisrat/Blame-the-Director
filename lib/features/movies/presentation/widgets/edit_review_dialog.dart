import 'package:flutter/material.dart';

import '../../../movies/data/models/review_model.dart';

class EditReviewDialog extends StatefulWidget {
  final ReviewModel review;
  final void Function(ReviewModel) onSubmit;

  const EditReviewDialog({
    super.key,
    required this.review,
    required this.onSubmit,
  });

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  late TextEditingController _controller;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.review.reviewText);
    _rating = widget.review.rating;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    widget.onSubmit(widget.review.copyWith(reviewText: text, rating: _rating));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Update verdict'),
          const SizedBox(height: 2),
          Text(
            widget.review.movieTitle,
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
                hintText: 'Still their fault...',
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
        ElevatedButton(onPressed: _submit, child: const Text('Update verdict')),
      ],
    );
  }
}
