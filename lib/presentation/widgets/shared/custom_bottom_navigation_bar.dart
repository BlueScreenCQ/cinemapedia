import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({super.key, required this.currentIndex});

  void onItemTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home/0');
        break;
      case 1:
        context.go('/home/1');
        break;
      case 2:
        context.go('/home/2');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(elevation: 0, onTap: (index) => onItemTap(context, index), currentIndex: currentIndex, items: const [
      BottomNavigationBarItem(icon: Icon(Icons.movie_outlined), label: 'Películas'),
      BottomNavigationBarItem(icon: Icon(Icons.live_tv_outlined), label: 'Series'),
      BottomNavigationBarItem(icon: Icon(Icons.list_outlined), label: 'Listas'),
    ]);
  }
}
