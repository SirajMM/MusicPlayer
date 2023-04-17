// ignore_for_file: sized_box_for_whitespace

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/screens/miniplayer.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blaze_player/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/recentlyplayedmodel.dart';
import 'home_screen.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreen();
}

class _RecentlyPlayedScreen extends State<RecentlyPlayedScreen> {
  List<Audio> recentaudio = [];
  @override
  void initState() {
    recentSongdstoAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new)),
                      SizedBox(
                        width: size.width * 0.1,
                      ),
                      Text(
                        'Recently Played',
                        style: headingStyle,
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<Box<RecentlyPlayedSongs>>(
                    valueListenable: recentbox.listenable(),
                    builder: (context, dbrecent, child) {
                      List<RecentlyPlayedSongs> recentsongs =
                          dbrecent.values.toList().reversed.toList();
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) => recentsongs.isNotEmpty
                            ? GestureDetector(
                                onTap: () {
                                  audioPlayer1.open(
                                    Playlist(
                                      audios: recentaudio,
                                      startIndex: index,
                                    ),
                                    showNotification: true,
                                    loopMode: LoopMode.playlist,
                                  );
                                },
                                child: costemListTile(
                                  titile: recentsongs[index].songname,
                                  singer: recentsongs[index].artist,
                                  context: context,
                                  cover: QueryArtworkWidget(
                                    id: recentsongs[index].id!,
                                    type: ArtworkType.AUDIO,
                                    artworkFit: BoxFit.cover,
                                    artworkHeight: size.height * 0.08,
                                    artworkWidth: size.height * 0.08,
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(15)),
                                    nullArtworkWidget: Container(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                            'asset/images/moosic.jpg',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // index: index,
                                ),
                              )
                            : Text(
                                'No songs found',
                                style: homeStyle,
                              ),
                        itemCount:
                            recentsongs.length <= 10 ? recentsongs.length : 10,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }

  recentSongdstoAudio() {
    final List<RecentlyPlayedSongs> recentlyplayed =
        recentbox.values.toList().reversed.toList();
    for (var element in recentlyplayed) {
      recentaudio.add(
        Audio.file(
          element.songurl.toString(),
          metas: Metas(
            artist: element.artist,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
  }
}
