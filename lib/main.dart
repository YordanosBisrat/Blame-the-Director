import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const BlameTheDirectorApp());
}

class BlameTheDirectorApp extends StatelessWidget {
  const BlameTheDirectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Blame the Director',
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blame the Director 🎬'),
        backgroundColor: Colors.transparent,
      ),
      body: const Center(
        child: Text(
          'Every bad movie has someone to blame.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
