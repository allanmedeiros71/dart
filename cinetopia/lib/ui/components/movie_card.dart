import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 90,
          height: 120,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF000000),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Título do Filme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              'Laçamento: 10/10/2024',
              style: TextStyle(fontSize: 14, color: const Color(0XFFA5A5A5)),
            ),
          ],
        ),
      ],
    );
  }
}
