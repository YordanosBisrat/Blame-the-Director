import 'package:flutter/material.dart';

class EditReviewDialog extends StatefulWidget {
  final String initialText;

  final Function(String) onSubmit;

  const EditReviewDialog({
    super.key,
    required this.initialText,
    required this.onSubmit,
  });

  @override
  State<EditReviewDialog> createState() => _EditReviewDialogState();
}

class _EditReviewDialogState extends State<EditReviewDialog> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialText);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Review'),

      content: TextField(
        controller: controller,

        maxLines: 4,

        decoration: const InputDecoration(hintText: 'Edit your review...'),
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

          child: const Text('Update'),
        ),
      ],
    );
  }
}
