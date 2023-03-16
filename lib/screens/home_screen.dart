import 'package:audioplayers/audioplayers.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blaze_player/widgets/favorites.dart';
import 'package:blaze_player/widgets/library.dart';
import 'package:blaze_player/widgets/search.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../widgets/home.dart';

// ignore: camel_case_types
class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => Home_ScreenState();
}

final player = AudioPlayer();
Future<void> initPlayer() async {
  await player.setSource(AssetSource("music.mp3"));
}

// =============================================
IconData playicon = Icons.play_arrow;
bool isplaying = false;
const List<Widget> widgetOptions = <Widget>[
  MyHome(),
  FavScreen(),
  SearchScreen(),
  MyLibrary(),
];

// ignore: camel_case_types
class Home_ScreenState extends State<Home_Screen> {
  int _selectedIndex = 0;

  static final GlobalKey<ScaffoldState> _drawkey = GlobalKey<ScaffoldState>();
  ScrollController listScrollController = ScrollController();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _drawkey,
          extendBody: true,

          appBar: _selectedIndex == 0
              ? AppBar(
                  backgroundColor: Colors.transparent,
                  flexibleSpace: Container(
                      //   decoration: const BoxDecoration(
                      //       gradient: LinearGradient(
                      //           begin: Alignment.bottomCenter,
                      //           end: Alignment.topCenter,
                      //           colors: <Color>[Colors.amberAccent, Colors.red])),

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
            controller: listScrollController,
            child: Container(
              // decoration: const BoxDecoration(
              //   gradient: LinearGradient(
              //     begin: Alignment.topRight,
              //     end: Alignment.bottomLeft,
              //     // stops: [
              //     //   0.1,
              //     //   0.4,
              //     //   0.6,
              //     //   0.9,
              //     // ],
              //     colors: [
              //       // Colors.yellow,
              //       // Colors.red,
              //       Colors.indigo,
              //       Color.fromARGB(237, 241, 35, 21),
              //     ],
              //   ),
              // ),
              child: widgetOptions.elementAt(_selectedIndex),
            ),
          ),

          // /-----------BOTTOM NAVIGASTION------------

          bottomNavigationBar: navBar(),
          // -----DRAWER--------
          endDrawer: Drawer(
            child: ListView(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 207, 202, 202)),
                  child: Text(
                    'Settings',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.edit_notifications),
                  title: const Text('Notification'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.error_outline),
                  title: const Text('About'),
                ),
                ListTile(
                  onTap: () {
                    SystemNavigator.pop();
                  },
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text('Quit'),
                ),
              ],
            ),
          ),
        ),
      );

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (listScrollController.hasClients) {
        final position = listScrollController.position.minScrollExtent;
        listScrollController.animateTo(
          position,
          duration: const Duration(seconds: 1),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ========== GNav BAR ========
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
