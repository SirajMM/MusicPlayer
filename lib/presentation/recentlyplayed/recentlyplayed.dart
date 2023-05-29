// ignore_for_file: sized_box_for_whitespace

import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/presentation/miniplayer/miniplayer.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blaze_player/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';

class RecentlyPlayedScreen extends StatelessWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false).recentSongdstoAudio();
    });

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
                Consumer<HomeProvider>(builder: (context, value, child) {
                  log(value.recentsongs.toString());
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => value
                            .recentsongs.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              audioPlayer1.open(
                                Playlist(
                                  audios: value.recentAudio,
                                  startIndex: index,
                                ),
                                showNotification: true,
                                loopMode: LoopMode.playlist,
                              );
                            },
                            child: costemListTile(
                              titile: value.recentsongs[index].songname,
                              singer: value.recentsongs[index].artist,
                              context: context,
                              cover: QueryArtworkWidget(
                                id: value.recentsongs[index].id!,
                                type: ArtworkType.AUDIO,
                                artworkFit: BoxFit.cover,
                                artworkHeight: size.height * 0.08,
                                artworkWidth: size.height * 0.08,
                                artworkBorder:
                                    const BorderRadius.all(Radius.circular(15)),
                                nullArtworkWidget: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
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
                    itemCount: value.recentsongs.length <= 10
                        ? value.recentsongs.length
                        : 10,
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
}
