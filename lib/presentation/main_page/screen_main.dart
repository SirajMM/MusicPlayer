import 'package:flutter/material.dart';

import '../favourite/favorites.dart';
import '../home/home_screen.dart';
import '../playlist/library.dart';
import '../search/search.dart';
import 'bottomnavigation.dart';

class ScreenMain extends StatelessWidget {
  ScreenMain({super.key});
  final List<Widget> _widgetOptions = <Widget>[
    const HomePage(),
    FavScreen(),
    const SearchScreen(),
    MyLibrary(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int index, child) => _widgetOptions[index],
      )),
      bottomNavigationBar: const Bottomnav(),
    );
  }
}
