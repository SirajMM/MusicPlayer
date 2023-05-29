// ignore_for_file: sized_box_for_whitespace
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/presentation/miniplayer/miniplayer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../styles/stile1.dart';
import '../../widgets/customlisttile.dart';
import '../home/home_screen.dart';

// ignore: must_be_immutable
class MostlyPlayedScreen extends StatelessWidget {
  const MostlyPlayedScreen({super.key});

  // final box = MostlyPlayedBox.getInstance();

  // List<Audio> mostconvertedaudio = [];
  // List<MostlyPlayedSongs> mostplayedsongs = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Provider.of<HomeProvider>(context, listen: true).mostPlayedConvertAudio();
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
          child: Consumer<HomeProvider>(
            builder: (context, value, child) {
              return value.mostplayedsongs.isNotEmpty
                  ? ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          audioPlayer1.open(
                              Playlist(
                                audios: value.mostconvertedaudio,
                                startIndex: index,
                              ),
                              showNotification: true);
                        },
                        child: costemListTile(
                          titile: value.mostplayedsongs[index].songname,
                          singer: value.mostplayedsongs[index].artist,
                          context: context,
                          cover: QueryArtworkWidget(
                            id: value.mostplayedsongs[index].id!,
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
                      itemCount: value.mostplayedsongs.length < 10
                          ? value.mostplayedsongs.length
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
