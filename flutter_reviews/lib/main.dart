import 'package:flutter/material.dart';
import 'package:flutter_reviews/ui/main_screen.dart';
import 'package:flutter_reviews/helper/review.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MainScreen(review: getRandomReview()));
  }
}
