import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/movies/presentation/pages/home_page.dart';

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
