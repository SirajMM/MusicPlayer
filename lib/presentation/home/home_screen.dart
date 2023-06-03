// ignore_for_file: use_build_context_synchronously, unused_element, sort_child_properties_last, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/application/splash_provider/splash_provider.dart';
import 'package:blaze_player/presentation/mostlyplayed/mostlyplayed.dart';
import 'package:blaze_player/presentation/recentlyplayed/recentlyplayed.dart';
import 'package:blaze_player/presentation/nowplaying/currentplayingscreen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../db/functions/db_functions.dart';
import '../../db/model/mostlyplayedmodel.dart';
import '../../db/model/recentlyplayedmodel.dart';
import '../../db/model/songmodel.dart';
import '../../styles/stile1.dart';
import '../../widgets/utlities.dart';
import '../miniplayer/miniplayer.dart';
import 'widgets/drawer_custom.dart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final rsize = MediaQuery.of(context).size;
    final rheight = MediaQuery.of(context).size.height;
    // final rwidth = MediaQuery.of(context).size.width;
    Provider.of<HomeProvider>(context, listen: false).allsSongsAudioadd();
    Future<void> handleRefresh() async {}
    final _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
              //
            },
            icon: const Icon(
              CupertinoIcons.arrow_2_circlepath,
            ),
          ),
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(
              Iconsax.menu_1,
              size: 28,
            ),
          )
        ],
      ),
      endDrawer: const DrawerWidget(),
      body: Container(
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
                            builder: (context) => const RecentlyPlayedScreen(),
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
                          audioPlayer1.open(
                              Playlist(
                                  audios: Provider.of<HomeProvider>(context)
                                      .convertAudios,
                                  startIndex: 0),
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
                        icon: const Icon(Iconsax.play5),
                        label: const Text('Play all'))
                  ],
                ),
                SizedBox(
                  height: rheight * 0.01,
                ),
                //============ All Songs ==================
                Consumer<SplashProvider>(
                  builder: (context, value, child) {
                    List<Songs> allDbSongs = value.box.values.toList();
                    return ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return allDbSongs.isNotEmpty
                              ? costemListTile(
                                  alldbsongs: value.allSongs,
                                  index: index,
                                  titile: allDbSongs[index].songname,
                                  mostplayedsong: mostplayedsong,
                                  singer:
                                      allDbSongs[index].artist == '<unknown>'
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
                                  context: context)
                              : const Center(
                                  child: Text('No songs found'),
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
      bottomSheet: MiniPlayer(),
    );
  }

// ====================== LISTTILE =======================
  Widget costemListTile(
      {String? titile,
      String? singer,
      Widget? cover,
      index,
      playingitem,
      alldbsongs,
      mostplayedsong,
      context}) {
    MostlyPlayedSongs mostsong = mostplayedsong[index];

    RecentlyPlayedSongs recentsongs;
    Songs songs = playingitem;
    return InkWell(
      onTap: () {
        // PlayScreen.currentindex.value = index!;
        audioPlayer1.open(
            Playlist(
                audios: Provider.of<HomeProvider>(context, listen: false)
                    .convertAudios,
                startIndex: index),
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
            Consumer<HomeProvider>(
              builder: (context, value, child) => IconButton(
                onPressed: () {
                  if (checkFavourite(songs.id, BuildContext)) {
                    Provider.of<HomeProvider>(context, listen: false)
                        .addToFavorite(songs.id!, context);
                  } else {
                    Provider.of<HomeProvider>(context, listen: false)
                        .addToFavorite(songs.id!, context);
                  }
                },
                icon: checkFavourite(songs.id, BuildContext)
                    ? const Icon(CupertinoIcons.heart)
                    : Icon(
                        CupertinoIcons.heart_solid,
                        color: buttoncolor,
                      ),
              ),
            ),
            IconButton(
                onPressed: () {
                  bottomSheet(context, index);
                },
                icon: const Icon(
                  Iconsax.music_square_add4,
                  size: 24,
                ))
          ],
        ),
      ),
    );
  }

  Widget showPopupMenu(songs, index, context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 1,
            child: Row(
              children: [
                Icon(Icons.playlist_add),
                SizedBox(
                  width: 10,
                ),
                Text('Add Toplaylist')
              ],
            ),
          ),
        ];
      },
    );
  }
}

final AssetsAudioPlayer audioPlayer1 = AssetsAudioPlayer.withId('0');

final List<MostlyPlayedSongs> mostplayedsong =
    mostlyplayedboxopen.values.toList();
