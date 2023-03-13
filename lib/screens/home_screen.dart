import 'package:blaze_player/widgets/favorites.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/home.dart';

// ignore: camel_case_types
class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => Home_ScreenState();
}

final TextStyle homeStyle =
    GoogleFonts.genos(fontSize: 25, fontWeight: FontWeight.w400);

// ignore: camel_case_types
class Home_ScreenState extends State<Home_Screen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static const List<Widget> _widgetOptions = <Widget>[
    MyHome(),
    FavScreen(),
    Text(
      'Search',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  static final GlobalKey<ScaffoldState> drawkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          key: Home_ScreenState.drawkey,
          extendBody: true,

          // ------------BODY---------------
          body: Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),

          // /-----------BOTTOM NAVIGASTION------------

          bottomNavigationBar: navBar(),
          // -----DRAWER--------
          endDrawer: Drawer(
            // elevation: 0.0,
            child: ListView(
              // ignore: prefer_const_literals_to_create_immutables
              children: [const DrawerHeader(child: Text('Settings'))],
            ),
          ),
        ),
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ---------GNav BAR---------
  Widget navBar() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: BlurryContainer(
          blur: 8,
          height: 60,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: const Color.fromARGB(26, 49, 21, 21),

          
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 0,
              vertical: 0,
            ),
            child: GNav(
              haptic: false,
              activeColor: Colors.deepOrangeAccent,
              color: Colors.grey,
              tabBorderRadius: 20,
              rippleColor: const Color.fromARGB(255, 236, 129, 7),
              tabActiveBorder:
                  Border.all(color: Colors.deepOrangeAccent, width: 1),
              gap: 8,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              selectedIndex: _selectedIndex,
              onTabChange: _onItemTapped,
              // ignore: prefer_const_literals_to_create_immutables
              tabs: [
                // ignore: prefer_const_constructors
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                // ignore: prefer_const_constructors
                GButton(
                  icon: Icons.favorite_border,
                  text: 'Favorite',
                ),
                // ignore: prefer_const_constructors
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                // ignore: prefer_const_constructors
                GButton(
                  icon: Icons.playlist_play,
                  text: 'Library',
                ),
              ],
            ),
          ),
        ),
      );
  // ignore: prefer_typing_uninitialized_variables
}
