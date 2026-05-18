import 'package:flutter/material.dart';

class AddReviewDialog extends StatefulWidget {
  final Function(String) onSubmit;

  const AddReviewDialog({super.key, required this.onSubmit});

  @override
  State<AddReviewDialog> createState() => _AddReviewDialogState();
}

class _AddReviewDialogState extends State<AddReviewDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Review'),

      content: TextField(
        controller: controller,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Write your review...'),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),

        ElevatedButton(
          onPressed: () {
            widget.onSubmit(controller.text);

            Navigator.pop(context);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
