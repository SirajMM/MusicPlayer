// ignore_for_file: prefer_const_constructors

import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/screens/search.dart';
import 'package:blaze_player/screens/settings/privacy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:share_plus/share_plus.dart';
import '../screens/settings/aboutus.dart';
import '../screens/settings/termsandconditions.dart';
import '../styles/stile1.dart';
import '../screens/favorites.dart';
import '../screens/library.dart';

// import 'package:sampleapp/likedsongs.dart';

class Bottomnav extends StatefulWidget {
  const Bottomnav({
    super.key,
  });

  @override
  State<Bottomnav> createState() => BottomnavState();
}

class BottomnavState extends State<Bottomnav> {
  int selectedIndex = 0;

  List<Widget> widgetOptions = <Widget>[
    const HomePage(),
    const FavScreen(),
    const SearchScreen(),
    const MyLibrary(),
  ];
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // ================== APPBAR =================
        appBar: selectedIndex == 0
            ? AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {},
                  icon: Image.asset('asset/images/Homelogo.png'),
                ),
                title: Text(
                  'Blaze Player',
                  style: topStyle,
                ),
              )
            : null,

        // ===============DRAWER=======================

        endDrawer: Drawer(
          child: ListView(children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          'asset/images/settings-removebg-preview.png')),
                  color: Color.fromARGB(255, 207, 202, 202)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style: headingStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditions_Screen(),
                    ));
              },
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Terms & Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyPolicy(),
                    ));
              },
              leading: const Icon(Icons.lock_outline),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AboutUs(),
                    ));
              },
              leading: const Icon(Icons.error_outline),
              title: const Text('About'),
            ),
            ListTile(
              onTap: () {
                Share.share('https://github.com/SirajMM/MusicPlayer',
                    subject: 'My GitHub repo Link');
              },
              leading: const Icon(Icons.share),
              title: const Text('Share'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);

                //  ==================== SHOW DIALOUGE ===============

                showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Confirm Exit'),
                    content: const Text('Do you want to exit app ?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: textcolor),
                        ),
                      ),
                      TextButton(
                        onPressed: () => SystemNavigator.pop(),
                        child: Text(
                          'Exit',
                          style: TextStyle(color: buttoncolor),
                        ),
                      ),
                    ],
                  ),
                );
              },
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Quit'),
            ),
          ]),
        ),
        body: widgetOptions.elementAt(selectedIndex),

        // =============== BOTTOM NAVIGATION BAR =================
        bottomNavigationBar: navBar(),
      ),
    );
  }

  Widget navBar() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          height: 55,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            color: const Color.fromARGB(26, 49, 21, 21),
          ),
          child: GNav(
            tabBackgroundColor: Colors.transparent,
            haptic: false,
            activeColor: textcolor,
            color: Colors.grey,
            tabBorderRadius: 25,
            rippleColor: Color.fromARGB(165, 0, 0, 0),
            tabActiveBorder: Border.all(color: textcolor, width: 1.5),
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
            selectedIndex: selectedIndex,
            onTabChange: onItemTapped,

            // ignore: prefer_const_literals_to_create_immutables
            tabs: [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.favorite_border,
                text: 'Favorite',
              ),
              GButton(
                icon: Icons.search,
                text: 'Search',
              ),
              GButton(
                icon: Icons.playlist_play,
                text: 'Library',
              ),
            ],
          ),
        ),
      );
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
