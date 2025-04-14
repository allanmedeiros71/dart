import 'package:flutter/material.dart';
import 'package:flutter_reviews/helper/review.dart';
import 'package:flutter_reviews/models/review.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final stars = List.generate(
      review.stars,
      (index) => Image.asset('assets/images/star.png', width: 20, height: 20),
    );

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${review.name} (${review.year})",
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              Row(children: stars),
              // Only date in dd/MM/yyyy format
              Text("Data: ${formatDate(review.date, format: "dd/MM/yyyy")}", style: const TextStyle(fontSize: 18)),
              Text(review.review, style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
