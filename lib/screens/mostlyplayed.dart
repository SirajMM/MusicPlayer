// ignore_for_file: sized_box_for_whitespace

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/mostlyplayedmodel.dart';
import 'package:blaze_player/screens/miniplayer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../styles/stile1.dart';
import '../widgets/customlisttile.dart';
import 'home_screen.dart';

class MostlyPlayedScreen extends StatefulWidget {
  const MostlyPlayedScreen({super.key});

  @override
  State<MostlyPlayedScreen> createState() => _MostlyPlayedScreenState();
}

class _MostlyPlayedScreenState extends State<MostlyPlayedScreen> {
  final box = MostlyPlayedBox.getInstance();
  List<Audio> mostconvertedaudio = [];
  @override
  void initState() {
    // mostSongstoAudio();
    List<MostlyPlayedSongs> mostsong = box.values.toList();
    int count = 0;
    mostsong.sort((a, b) => b.count!.compareTo(a.count!));
    for (var element in mostsong) {
      if (element.count! > 2) {
        mostplayedsongs.insert(count, element);
        count++;
      }
    }
    for (var element in mostplayedsongs) {
      mostconvertedaudio.add(Audio.file(
        element.songurl!,
        metas: Metas(
          title: element.songname,
          artist: element.artist,
          id: element.id.toString(),
        ),
      ));
    }
    super.initState();
  }

  List<MostlyPlayedSongs> mostplayedsongs = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          'Mostly Played',
          style: headingStyle,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, value, child) {
              return mostplayedsongs.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          audioPlayer1.open(
                              Playlist(
                                audios: mostconvertedaudio,
                                startIndex: index,
                              ),
                              showNotification: true);
                        },
                        child: costemListTile(
                          titile: mostplayedsongs[index].songname,
                          singer: mostplayedsongs[index].artist,
                          context: context,
                          cover: QueryArtworkWidget(
                            id: mostplayedsongs[index].id!,
                            type: ArtworkType.AUDIO,
                            artworkHeight: size.height * 0.08,
                            artworkWidth: size.height * 0.08,
                            artworkBorder:
                                const BorderRadius.all(Radius.circular(15)),
                            nullArtworkWidget: Container(
                              height: size.height * 0.08,
                              width: size.height * 0.08,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'asset/images/moosic.jpg'))),
                            ),
                          ),
                        ),
                      ),
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                      itemCount: mostplayedsongs.length < 10
                          ? mostplayedsongs.length
                          : 10,
                    )
                  : Container(
                      height: size.height,
                      child: Center(
                        child: Text(
                          'No songs found',
                          style: homeStyle,
                        ),
                      ),
                    );
            },
          ),
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}
