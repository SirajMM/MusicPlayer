// ignore_for_file: use_build_context_synchronously, unused_element, sort_child_properties_last, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/db_functions.dart';
import 'package:blaze_player/model/mostlyplayedmodel.dart';
import 'package:blaze_player/model/songmodel.dart';
import 'package:blaze_player/screens/functions/addtofav.dart';
import 'package:blaze_player/screens/mostlyplayed.dart';
import 'package:blaze_player/screens/recentlyplayed.dart';
import 'package:blaze_player/screens/currentplayingscreen.dart';
import 'package:blaze_player/screens/splash_screen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../model/recentlyplayedmodel.dart';
import '../styles/stile1.dart';
import '../widgets/utlities.dart';
import 'miniplayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

Map isplayingMap = {};
final alldbsongs = SongBox.getInstance();

final songbox = SongBox.getInstance();

List<Songs> dbsongs = alldbsongs.values.toList();
final OnAudioQuery _audioQuery = OnAudioQuery();

final AssetsAudioPlayer audioPlayer1 = AssetsAudioPlayer.withId('0');
final recentbox = RecentlyPlayedBox.getinstance();
final List<MostlyPlayedSongs> mostplayedsong =
    mostlyplayedboxopen.values.toList();
List<MostlyPlayedSongs> mostfulllist = [];

class _HomePageState extends State<HomePage> {
  List<Audio> convertAudios = [];

  Future<void> handleRefresh() async {
    await box.clear();
    allSongs.clear();
    mostlyplayedboxopen.clear();
    convertAudios.clear();

    getSongs = await _audioQuery.querySongs();
    allSongs = getSongs.where((song) => song.fileExtension == 'mp3').toList();
    for (var element in allSongs) {
      await box.add(Songs(
          songname: element.title,
          artist: element.artist,
          duration: element.duration,
          songurl: element.uri,
          id: element.id));
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
    setState(() {
      allsSongsAudioadd();
    });
  }

  @override
  void initState() {
    allsSongsAudioadd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final rsize = MediaQuery.of(context).size;
    final rheight = MediaQuery.of(context).size.height;
    // final rwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // backgroundColor: Colors.black,
      body: LiquidPullToRefresh(
        springAnimationDurationInMilliseconds: 700,
        onRefresh: handleRefresh,
        showChildOpacityTransition: false,
        backgroundColor: buttoncolor,
        color: Colors.transparent,
        child: Container(
          height: rheight,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // ========== Recentlyplayed card ==============
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const RecentlyPlayedScreen(),
                            )),
                        child: buildcard('Recently Played',
                            'asset/images/recently played.webp', rsize),
                      ),
                      // ========== Mostlyplayed Card ================
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MostlyPlayedScreen(),
                            )),
                        child: buildcard('Mostly Played',
                            'asset/images/mostplayed.jpg', rsize),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: rheight * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'All Songs',
                        style: homeStyle,
                      ),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: buttoncolor,
                            foregroundColor: Colors.white,
                            elevation: 5,
                          ),
                          onPressed: () {
                            // PlayScreen.currentindex.value = 0;
                            audioPlayer1.open(
                                Playlist(audios: convertAudios, startIndex: 0),
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                                showNotification: true,
                                loopMode: LoopMode.playlist);
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => CurrentPlayingScreen(
                                        player: audioPlayer1)));
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play all'))
                    ],
                  ),
                  SizedBox(
                    height: rheight * 0.01,
                  ),
                  //============ All Songs ==================
                  ValueListenableBuilder<Box<Songs>>(
                    valueListenable: songbox.listenable(),
                    builder: (context, Box<Songs> allsongbox, child) {
                      List<Songs> allDbSongs = allsongbox.values.toList();

                      return ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return costemListTile(
                              alldbsongs: allDbSongs,
                              index: index,
                              titile: allDbSongs[index].songname,
                              mostplayedsong: mostplayedsong,
                              singer: allDbSongs[index].artist == '<unknown>'
                                  ? 'Artist not found'
                                  : allDbSongs[index].artist,
                              playingitem: allDbSongs[index],
                              cover: ClipRect(
                                child: QueryArtworkWidget(
                                    nullArtworkWidget: Container(
                                      height: rheight * 0.08,
                                      width: rheight * 0.08,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                  'asset/images/moosic.jpg'))),
                                    ),
                                    artworkBorder: const BorderRadius.all(
                                        Radius.circular(16)),
                                    artworkHeight: rheight * 0.08,
                                    artworkWidth: rheight * 0.08,
                                    artworkFit: BoxFit.cover,
                                    id: allDbSongs[index].id!,
                                    type: ArtworkType.AUDIO),
                              ),
                              //         );
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: rheight * 0.01,
                              ),
                          itemCount: allDbSongs.length);
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }

// ====================== LISTTILE =======================

  Widget costemListTile({
    String? titile,
    String? singer,
    Widget? cover,
    index,
    playingitem,
    alldbsongs,
    mostplayedsong,
  }) {
    MostlyPlayedSongs mostsong = mostplayedsong[index];
    bool isPlaying = isplayingMap[index] ?? false;
    // bool isPlaying = audioPlayer1.isPlaying.value;
    RecentlyPlayedSongs recentsongs;
    Songs songs = alldbsongs[index];
    return InkWell(
      onTap: () {
        // PlayScreen.currentindex.value = index!;
        audioPlayer1.open(Playlist(audios: convertAudios, startIndex: index),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true,
            loopMode: LoopMode.playlist);
        recentsongs = RecentlyPlayedSongs(
            artist: songs.artist,
            songname: songs.songname,
            duration: songs.duration,
            id: songs.id,
            songurl: songs.songurl);
        addrecentlyplayed(recentsongs);
        addPlayedSongsCount(mostsong, index);
        Navigator.push(
          context,
          CupertinoPageRoute(
            fullscreenDialog: true,
            builder: (context) => CurrentPlayingScreen(player: audioPlayer1),
          ),
        );
      },
      child: BlurryContainer(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(11, 58, 13, 219),
        elevation: 02,
        blur: 100,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              child: cover,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titile!,
                    style: songnamestyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Text(
                    singer!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(
              width: 10,
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    isPlaying = !isPlaying;
                    isplayingMap[index] = isPlaying;
                  });
                  if (isPlaying) {
                    audioPlayer1.open(
                        Playlist(audios: convertAudios, startIndex: index),
                        headPhoneStrategy:
                            HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                        showNotification: true,
                        loopMode: LoopMode.playlist);
                    audioPlayer1.play();
                  } else {
                    audioPlayer1.pause();
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
            const SizedBox(
              width: 10,
            ),
            // ================== POPUP MENU =======================
            showPopupMenu(songs.id, index),
          ],
        ),
      ),
    );
  }

  Widget showPopupMenu(songs, index) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 1,
            child: Row(
              children: const [
                Icon(Icons.playlist_add),
                SizedBox(
                  width: 10,
                ),
                Text('Add Toplaylist')
              ],
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: Row(
              children: [
                checkFavourite(songs, BuildContext)
                    ? const Icon(Icons.favorite_outline)
                    : Icon(
                        Icons.favorite,
                        color: buttoncolor,
                      ),
                const SizedBox(
                  width: 10,
                ),
                checkFavourite(songs, BuildContext)
                    ? const Text('Add to Favorite')
                    : const Text('Remove')
              ],
            ),
          ),
        ];
      },
      onSelected: (value) async {
        switch (value) {
          case 1:
            // ========== BOTTOMSHEET ===============
            bottomSheet(context, index);
            break;
          case 2:
            ScaffoldMessenger.of(context).clearSnackBars();
            if (checkFavourite(songs, BuildContext)) {
              addToFavorite(songs);
              final snackBar = SnackBar(
                content: Row(
                  children: [
                    const Text('Added to favorite '),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.favorite,
                      color: buttoncolor,
                    )
                  ],
                ),
                dismissDirection: DismissDirection.down,
                behavior: SnackBarBehavior.floating,
                elevation: 30,
                duration: const Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (!checkFavourite(songs, BuildContext)) {
              removeFav(songs);
              final snackBar = SnackBar(
                content: Row(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Text('Removed from favourite'),
                    const SizedBox(
                      width: 10,
                    ),
                    const Icon(
                      Icons.favorite_outline,
                      color: Colors.white,
                    )
                  ],
                ),
                dismissDirection: DismissDirection.down,
                behavior: SnackBarBehavior.floating,
                elevation: 30,
                duration: const Duration(seconds: 1),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }

            break;
        }
      },
    );
  }

  allsSongsAudioadd() {
    log('hahaha');
    List<Songs> dbsogs = songbox.values.toList();
    for (var element in dbsogs) {
      convertAudios.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          ),
        ),
      );
    }
  }
}
