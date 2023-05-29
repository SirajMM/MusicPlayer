// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, avoid_unnecessary_containers, prefer_const_constructors
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/presentation/home/home_screen.dart';
import 'package:blaze_player/presentation/miniplayer/miniplayer.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blaze_player/presentation/nowplaying/currentplayingscreen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class FavScreen extends StatelessWidget {
  FavScreen({super.key});

  IconData playicon = Icons.play_arrow;

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
            child: Consumer<HomeProvider>(builder: (context, value, child) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Provider.of<HomeProvider>(context, listen: false)
                    .favConvertAudio();
              });
              return Column(
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
                          Provider.of<HomeProvider>(context, listen: false)
                              .shuffle();
                          if (value.isShuffle) {
                            _audioplayer.toggleShuffle();
                            _audioplayer.open(
                                Playlist(audios: value.favsongs, startIndex: 0),
                                showNotification: true,
                                headPhoneStrategy:
                                    HeadPhoneStrategy.pauseOnUnplug,
                                loopMode: LoopMode.playlist);
                          } else {
                            _audioplayer.stop();
                          }
                        },
                        icon: (value.isShuffle)
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
                              Playlist(audios: value.favsongs, startIndex: 0),
                              showNotification: true,
                              headPhoneStrategy:
                                  HeadPhoneStrategy.pauseOnUnplug,
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
                  value.favorites.isNotEmpty
                      ? ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                          itemCount: value.favorites.length,
                          itemBuilder: (context, index) => InkWell(
                            onTap: () {
                              _audioplayer.open(
                                  Playlist(
                                      audios: value.favsongs,
                                      startIndex: index),
                                  showNotification: true,
                                  headPhoneStrategy:
                                      HeadPhoneStrategy.pauseOnUnplug,
                                  loopMode: LoopMode.playlist);
                            },
                            child: costemListTile(
                                index: index,
                                titile: value.favorites[index].songname,
                                singer: value.favorites[index].artist,
                                favsongs1: value.favorites,
                                context: context),
                          ),
                        )
                      : Container(
                          height: size.width * 1.3,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                  'https://assets9.lottiefiles.com/packages/lf20_khnalzic.json',
                                  height: size.height * .25),
                              Text(
                                "No Liked  songs Found!",
                                style: homeStyle,
                              ),
                            ],
                          ),
                        ),
                ],
              );
            }),
          ),
        ),
        bottomSheet: MiniPlayer(),
      ),
    );
  }

  Widget costemListTile(
      {String? titile, String? singer, favsongs1, index, context}) {
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
              onPressed: () {
                Provider.of<HomeProvider>(context, listen: false)
                    .addToFavorite(favsongs1[index].id!, context);
                ScaffoldMessenger.of(context).clearSnackBars();

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
              },
              icon: Icon(Icons.favorite),
            ),
          ],
        ),
      ),
    );
  }
}

final _audioplayer = AssetsAudioPlayer.withId('0');
