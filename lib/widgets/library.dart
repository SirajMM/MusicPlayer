// import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/screens/likedsongs.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';

class MyLibrary extends StatefulWidget {
  const MyLibrary({super.key});

  @override
  State<MyLibrary> createState() => _MyLibraryState();
}

class _MyLibraryState extends State<MyLibrary> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // ignore: sized_box_for_whitespace
    return Container(
      height: size.height,
      width: size.width,
      child: ListView(children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Playlist',
                style: headingStyle,
              ),
            ),
            // ===========Play List==============
            Container(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Create Playlist'),
                    content: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter name of the playlist',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Create'),
                        child: const Text(
                          'Create',
                        ),
                      ),
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * 0.085,
                      width: size.width * 0.18,
                      decoration: BoxDecoration(
                          color: buttoncolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.height * 0.02,
                    ),
                    Expanded(
                      child: Text(
                        'Create Playlist',
                        style: homeStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // =========Liked Songs=========
            Container(
              padding: const EdgeInsets.all(8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LikedSongs(),
                      ));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * 0.085,
                      width: size.width * 0.18,
                      decoration: BoxDecoration(
                          color: buttoncolor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15))),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Liked Songes',
                            style: homeStyle,
                          ),
                          const Text('160 songs')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }
}
