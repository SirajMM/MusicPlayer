// ignore_for_file: use_build_context_synchronously

import 'package:blaze_player/screens/home_screen.dart';
// import 'package:blaze_player/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => MyWidgetState();
}

class MyWidgetState extends State<MyHome> {
  bool isplaying = false;
  IconData playicon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.all(8),
      // decoration: const BoxDecoration(color: Colors.white),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Played',
                style: homeStyle,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'Discover >',
                  style: GoogleFonts.genos(
                      // ignore: prefer_const_constructors
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrangeAccent)),
                ),
              )
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          // ignore: sized_box_for_whitespace
          songCard(),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Most Played',
                style: homeStyle,
              ),
              InkWell(
                onTap: () {
                  setState(() {});
                },
                child: Text(
                  'Discover >',
                  style: GoogleFonts.genos(
                      // ignore: prefer_const_constructors
                      textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.deepOrangeAccent)),
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          songCard(),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            'Songs',
            style: homeStyle,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          // ignore: sized_box_for_whitespace
          Container(
            height: size.height,
            child: ValueListenableBuilder(
              valueListenable: Hive.box('favorites').listenable(),
              builder: (context, box, child) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 10,
                  // ignore: prefer_const_constructors
                  itemBuilder: (context, index) => costemListTile(
                      titile: "Samjhavan",
                      singer: 'Arjith Sign',
                      cover: 'asset/images/Geena mera.jpg'),
                );
              },
            ),
          ),
          SizedBox(
            height: size.height * 0.07,
          )
        ],
      ),
    );
    // -----------DRAWER------------
  }

  // ignore: sized_box_for_whitespace
  Widget songCard() => Container(
        height: MediaQuery.of(context).size.height * 0.19,
        child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => buildcard(),
            separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
            itemCount: 5),
      );
  Widget buildcard() => InkWell(
        onTap: () {
          // print('hii');
        },
        child: Stack(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.height * 0.19,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                  image: AssetImage('asset/images/Geena mera.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          Positioned(
            bottom: 2,
            left: 10,
            child: BlurryContainer(
              width: MediaQuery.of(context).size.width * 0.35,
              child: Text(
                'Samjhavan',
                textAlign: TextAlign.center,
                style: GoogleFonts.genos(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ]),
      );

  Widget costemListTile(
      {String? titile, String? singer, String? cover, onTap}) {
    var hiveBox = Hive.box('favorites');
    final isFavorite = hiveBox.get(titile) != null;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                image: DecorationImage(
                    image: AssetImage(cover!), fit: BoxFit.cover)),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titile!,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(singer!),
              ],
            ),
          ),
          IconButton(
            color: Colors.red,
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (isFavorite) {
                await hiveBox.delete(titile);
                const snackBar = SnackBar(
                  content: Text('Removed from favorite'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                await hiveBox.put(titile, cover);
                const snackBar = SnackBar(
                  content: Text('Added to favorite'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              // await hiveBox.put(titile, cover);

              // ScaffoldMessenger.of(context).clearSnackBars();
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
          IconButton(
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
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
    );
  }
}
