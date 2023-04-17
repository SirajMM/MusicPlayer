// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, avoid_unnecessary_containers, prefer_const_constructors
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/favoritemodel.dart';
import 'package:blaze_player/screens/functions/addtofav.dart';
import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/screens/miniplayer.dart';
// import 'package:blaze_player/screens/playsreen.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blaze_player/screens/currentplayingscreen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

Map isplayingMap = {};
// bool isplaying = false;

bool isShuffle = false;
final _audioplayer = AssetsAudioPlayer.withId('0');

class _FavScreenState extends State<FavScreen> {
  final List<FavSongs> favorite = [];
  final box = FavBox.getInstance();
  late List<FavSongs> favorite3 = box.values.toList();

  bool isFavorite = true;
  List<Audio> favsongs = [];
  IconData playicon = Icons.play_arrow;

  @override
  void initState() {
    favdbaddAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Container(
          height: size.height,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('Favorite Songs', style: headingStyle),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          isShuffle = !isShuffle;
                        });
                        if (isShuffle) {
                          _audioplayer.toggleShuffle();
                          _audioplayer.open(
                              Playlist(audios: favsongs, startIndex: 0),
                              showNotification: true,
                              headPhoneStrategy:
                                  HeadPhoneStrategy.pauseOnUnplug,
                              loopMode: LoopMode.playlist);
                        } else {
                          _audioplayer.stop();
                        }
                      },
                      icon: (isShuffle)
                          ? Icon(Icons.shuffle_on_outlined)
                          : Icon(Icons.shuffle),
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
                      onPressed: () {
                        _audioplayer.open(
                            Playlist(audios: favsongs, startIndex: 0),
                            showNotification: true,
                            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                            loopMode: LoopMode.playlist);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CurrentPlayingScreen(
                                player: audioPlayer1,
                                // index: 0,
                              ),
                            ));
                      },
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
                ValueListenableBuilder(
                  valueListenable: box.listenable(),
                  builder: (context, favoritedb, child) {
                    List<FavSongs> favsongs1 =
                        favoritedb.values.toList().reversed.toList();
                    return favsongs1.isNotEmpty
                        ? ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) => SizedBox(
                              height: 10,
                            ),
                            itemCount: favsongs1.length,
                            itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                _audioplayer.open(
                                    Playlist(
                                        audios: favsongs, startIndex: index),
                                    showNotification: true,
                                    headPhoneStrategy:
                                        HeadPhoneStrategy.pauseOnUnplug,
                                    loopMode: LoopMode.playlist);
                              },
                              child: costemListTile(
                                  index: index,
                                  titile: favsongs1[index].songname,
                                  singer: favsongs1[index].artist,
                                  favsongs1: favsongs1),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: size.height * 0.3),
                            child: Text(
                              "No Liked  songs Found!",
                              style: homeStyle,
                            ),
                          );
                  },
                ),
              ],
            ),
          ),
        ),
        bottomSheet: MiniPlayer(),
      ),
    );
  }

  Widget costemListTile({String? titile, String? singer, favsongs1, index}) {
    // bool isPlaying = isplayingMap[index] ?? false;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: BlurryContainer(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        blur: 100,
        color: Color.fromARGB(11, 58, 13, 219),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              child: ClipRRect(
                child: QueryArtworkWidget(
                  id: favsongs1[index].id!,
                  keepOldArtwork: true,
                  type: ArtworkType.AUDIO,
                  artworkBorder: const BorderRadius.all(Radius.circular(10)),
                  nullArtworkWidget: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage('asset/images/moosic.jpg'))),
                  ),
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
                    titile!,
                    style: homeStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    singer!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            IconButton(
              color: buttoncolor,
              onPressed: () async {
                ScaffoldMessenger.of(context).clearSnackBars();
                deletefav(index, context);
                final snackbar = SnackBar(
                  content: Row(
                    children: const [
                      Text('Removed From Favorite '),
                      Icon(
                        Icons.favorite_outline,
                        color: Colors.white,
                      )
                    ],
                  ),
                  dismissDirection: DismissDirection.down,
                  behavior: SnackBarBehavior.floating,
                  elevation: 30,
                  duration: Duration(milliseconds: 500),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                setState(() {});
              },
              icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }

  favdbaddAudio() {
    final List<FavSongs> favorites = box.values.toList().reversed.toList();
    for (var element in favorites) {
      favsongs.add(
        Audio.file(
          element.songurl.toString(),
          metas: Metas(
            artist: element.artist!,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
  }
}
