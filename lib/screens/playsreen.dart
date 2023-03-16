// ignore_for_file: sized_box_for_whitespace
import 'dart:ui';
import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

bool isplaying = false;
IconData playicon = Icons.play_circle_fill;
bool isfavorite = false;
var likebutton = const Icon(
  Icons.favorite,
  size: 30,
);

class _PlayScreenState extends State<PlayScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
          ),
          title: Padding(
            padding: const EdgeInsets.all(.0),
            child: Text(
              'Playing',
              style: headingStyle,
            ),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image:
                        AssetImage('asset/images/player background them.webp')),

                // gradient: LinearGradient(
                //   begin: Alignment.topRight,
                //   end: Alignment.bottomLeft,
                //   colors: [
                //     Colors.amberAccent,
                //     Colors.red,
                //   ],
                // ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            Container(
              height: size.height,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: size.height * 0.18),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,

                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'asset/images/Geena mera.jpg',
                            fit: BoxFit.cover,
                            width: size.width * 0.7,
                            height: size.height * 0.35,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          'Samjhavan',
                          style: homeStyle,
                        ),
                        const Text('Arjith Singh'),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Slider.adaptive(
                          activeColor: Colors.redAccent,
                          inactiveColor: Colors.black,
                          value: 0.4,
                          onChanged: (value) {},
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('00:00'),
                            Text("00:00"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.skip_previous,
                          size: 35,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.replay_10,
                          size: 35,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isplaying) {
                            setState(() {
                              playicon = Icons.pause_circle;
                              isplaying = false;
                            });
                          } else {
                            setState(() {
                              playicon = Icons.play_circle_filled;
                              isplaying = true;
                            });
                          }
                        },
                        child: Icon(
                          playicon,
                          size: 35,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.forward_10,
                          size: 35,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.skip_next,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.06,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const InkWell(
                        child: Icon(
                          Icons.shuffle,
                          size: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (isfavorite) {
                            setState(() {
                              likebutton = const Icon(
                                Icons.favorite_outline,
                                size: 30,
                              );
                              isfavorite = false;
                            });
                          } else {
                            setState(() {
                              likebutton = const Icon(
                                Icons.favorite,
                                color: Color.fromARGB(255, 230, 9, 9),
                                size: 30,
                              );
                              isfavorite = true;
                            });
                          }
                        },
                        child: likebutton,
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.playlist_add,
                          size: 30,
                        ),
                      ),
                      const InkWell(
                        child: Icon(
                          Icons.repeat,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
