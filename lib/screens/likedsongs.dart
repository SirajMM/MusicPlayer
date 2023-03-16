import 'package:flutter/material.dart';


class LikedSongs extends StatefulWidget {
  const LikedSongs({super.key});

  @override
  State<LikedSongs> createState() => _LikedSongsState();
}

class _LikedSongsState extends State<LikedSongs> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('at liked songs')),
    );
  }
}
