// import 'dart:js';

import 'package:blaze_player/widgets/favorites.dart';
import 'package:blaze_player/widgets/library.dart';
import 'package:blaze_player/widgets/search.dart';
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

// =============== TEXT STYLES ==============
final TextStyle homeStyle =
    GoogleFonts.genos(fontSize: 25, fontWeight: FontWeight.w400);

final TextStyle headingStyle = GoogleFonts.italianno(
  fontSize: 38,
  fontWeight: FontWeight.w600,
  color: const Color.fromARGB(176, 0, 0, 0),
);

final TextStyle topStyle = GoogleFonts.italianno(
  fontSize: 26,
  fontWeight: FontWeight.w600,
  color: const Color.fromARGB(176, 0, 0, 0),
);
// =============================================
IconData playicon = Icons.play_arrow;
bool isplaying = false;
const List<Widget> widgetOptions = <Widget>[
  MyHome(),
  FavScreen(),
  SearchScreen(),
  MyLibrary(),
];
const TextStyle optionStyle =
    TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

// ignore: camel_case_types
class Home_ScreenState extends State<Home_Screen> {
  int _selectedIndex = 0;

  static final GlobalKey<ScaffoldState> _drawkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          key: _drawkey,
          extendBody: true,

          appBar: _selectedIndex == 0
              ? AppBar(
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: <Color>[Colors.amberAccent, Colors.red])),
                  ),
                  elevation: 0,
                  leading: IconButton(
                    onPressed: () {},
                    icon: Image.asset('asset/images/Homelogo.png'),
                  ),
                  title: Text(
                    'Blaze Player',
                    style: topStyle,
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        // ignore: non_constant_identifier_names
                        _drawkey.currentState?.openEndDrawer();
                      },
                      icon: const Icon(
                        Icons.format_align_right_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ],
                )
              : null,
          // ------------BODY---------------
          body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.amberAccent,
                    Colors.red,
                  ],
                )),
                child: widgetOptions.elementAt(_selectedIndex)),
          ),

          // /-----------BOTTOM NAVIGASTION------------

          bottomNavigationBar: navBar(),
          // -----DRAWER--------
          endDrawer: Drawer(
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

  playButton() {
    return IconButton(
      onPressed: () {
        if (isplaying) {
          setState(() {
            playicon = Icons.pause;
            isplaying = false;
          });
        } else {
          setState(() {
            playicon = Icons.play_arrow;
            isplaying = true;
          });
        }
      },
      icon: Icon(playicon),
    );
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
              tabBackgroundColor: Colors.transparent,
              haptic: false,
              activeColor: Colors.black,
              color: Colors.grey,
              tabBorderRadius: 20,
              rippleColor: Colors.black,
              tabActiveBorder: Border.all(color: Colors.black, width: 1.5),
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
}
