// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously
import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  bool isplaying = false;
  IconData playicon = Icons.play_arrow;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Favorite Songs', style: headingStyle),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.shuffle,
                ),
                label: const Text(
                  'Shuffle',
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(150, 50),
                  backgroundColor: buttoncolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text('Play'),
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 16),
                  minimumSize: const Size(150, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: buttoncolor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                icon: const Icon(Icons.play_arrow_outlined),
              ),
            ],
          ),
          SizedBox(
            height: size.height * 0.02,
          ),
          Container(
            height: size.height,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 20,
              itemBuilder: (context, index) => costemListTile(
                  titile: "Samjhavan",
                  singer: "Arjith Sing",
                  cover: 'asset/images/Geena mera.jpg'),
            ),
          ),
        ],
      ),
    );
  }

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
            color: buttoncolor,
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
