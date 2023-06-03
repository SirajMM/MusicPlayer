import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../styles/stile1.dart';

ValueNotifier<int> indexChangeNotifier = ValueNotifier(0);

// ignore: must_be_immutable
class Bottomnav extends StatelessWidget {
  const Bottomnav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
        valueListenable: indexChangeNotifier,
        builder: (context, int newIndex, child) {
          return Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 55,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color.fromARGB(26, 49, 21, 21),
              ),
              child: GNav(
                tabBackgroundColor: Colors.transparent,
                haptic: false,
                activeColor: textcolor,
                color: Colors.grey,
                tabBorderRadius: 25,
                rippleColor: const Color.fromARGB(165, 0, 0, 0),
                tabActiveBorder: Border.all(color: textcolor, width: 1.5),
                gap: 8,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                selectedIndex: newIndex,
                onTabChange: (index) => indexChangeNotifier.value = index,
                tabs: const [
                  GButton(
                    icon: CupertinoIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.favorite_border,
                    text: 'Favorite',
                  ),
                  GButton(
                    icon: CupertinoIcons.search,
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
        },
      ),
    );
  }
}
