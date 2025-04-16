import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 124,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(color: const Color(0xFF000000)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [Text('Título do Filme'), Text('Laçamento: 10/10/2024')],
        ),
      ],
    );
  }
}
