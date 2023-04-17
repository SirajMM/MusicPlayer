import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/mostlyplayedmodel.dart';
import 'package:blaze_player/model/songmodel.dart';
import 'package:blaze_player/widgets/bottomnavigation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../model/db_functions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

// final mostbox = MostlyPlayedBox.getInstance();

final box = SongBox.getInstance();
List<SongModel> allSongs = [];
List<SongModel> getSongs = [];

class _SplashScreenState extends State<SplashScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AssetsAudioPlayer();

  @override
  void initState() {
    super.initState();

    requestPermission();
  }

  requestPermission() async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();

      getSongs = await _audioQuery.querySongs();
      for (var element in getSongs) {
        if (element.fileExtension == 'mp3') {
          allSongs.add(element);
        }
      }

      for (var element in allSongs) {
        await box.add(Songs(
            songname: element.title,
            artist: element.artist,
            duration: element.duration,
            songurl: element.uri,
            id: element.id));
      }
      for (var element in allSongs) {
        mostlyplayedboxopen.add(
          MostlyPlayedSongs(
              songname: element.title,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri,
              count: 0),
        );
      }
    }
    await Future.delayed(
      const Duration(seconds: 1),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => const Bottomnav()),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset('asset/images/logo.png'),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Blaze Player',
                    style: GoogleFonts.italianno(
                        fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
