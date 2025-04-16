import 'package:cinetopia/ui/screens/releases.dart';
import 'package:cinetopia/ui/screens/search_movies.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> _screens = <Widget>[
    const SearchMovies(),
    const Releases(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => _onTap(value),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Filmes'),
          BottomNavigationBarItem(
            icon: Icon(Icons.today),
            label: 'Lançamentos',
          ),
        ],
      ),
    );
  }
}
