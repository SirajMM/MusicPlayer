// ignore_for_file: must_be_immutable, unused_local_variable, sized_box_for_whitespace, use_build_context_synchronously
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
import '../../db/model/playlistmodel.dart';
import '../../db/model/songmodel.dart';
import '../miniplayer/miniplayer.dart';

class PlaylistSongs extends StatelessWidget {
  PlaylistSongs(
      {super.key, required this.songindex, required this.playlistname});
  int? songindex;
  String? playlistname;

  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');

  final playbox = PlaylistBox.getInstance();

  @override
  Widget build(BuildContext context) {
    double rheight = MediaQuery.of(context).size.height;
    List<PlayListDb> playlistsong = playbox.values.toList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<HomeProvider>(context, listen: false)
          .convertPlaylistSongs(songindex);
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          playlistsong[songindex!].playlistname!,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: Consumer<HomeProvider>(builder: (context, value, child) {
        value.viewPlaylistAllSongs(songindex);
        return SizedBox(
          height: rheight,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  value.playsong.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: value.playsong.length,
                          itemBuilder: (context, index) => costemListTile(
                              titile: value.playsong[index].songname!,
                              singer: value.playsong[index].artist,
                              index: index,
                              playsong: value.playsong,
                              playlistsong: playlistsong,
                              context: context,
                              playListIndex: songindex),
                          separatorBuilder: (context, index) => SizedBox(
                            height: rheight * 0.01,
                          ),
                        )
                      : Container(
                          height: rheight,
                          child: Center(
                              child: Text(
                            'no songs',
                            style: homeStyle,
                          ))),
                ],
              ),
            ),
          ),
        );
      }),
      // floatingActionButton: SizedBox(
      //   height: 40,
      //   width: 150,
      //   child: FloatingActionButton(
      //     onPressed: () {
      //       allSongsSheet(
      //           context, playlistsong[widget.songindex!].playlistsongs);
      //     },
      //     child: Row(
      //       mainAxisAlignment: MainAxisAlignment.center,
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         const Icon(
      //           Icons.add,
      //         ),
      //         Text(
      //           'Add Song',
      //           style: homeStyle,
      //         )
      //       ],
      //     ),
      //   ),
      // ),
      bottomSheet: const MiniPlayer(),
    );
  }

  Widget costemListTile({
    String? titile,
    String? singer,
    index,
    List<Songs>? playsong,
    List? playlistsong,
    context,
    int? playListIndex,
  }) {
  
    final rheight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
       
        audioPlayer.open(
            Playlist(
                audios: Provider.of<HomeProvider>(context, listen: false)
                    .plalistSongsConvertAudio,
                startIndex: index),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true,
            loopMode: LoopMode.playlist);
      },
      child: BlurryContainer(
        // ignore: prefer_const_constructors
        color: Color.fromARGB(11, 58, 13, 219),
        elevation: 2,
        blur: 100,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: rheight * 0.08,
              width: rheight * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(width: .5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: QueryArtworkWidget(
                artworkHeight: rheight * 0.08,
                artworkWidth: rheight * 0.08,
                artworkBorder: const BorderRadius.all(Radius.circular(15)),
                artworkFit: BoxFit.fill,
                id: playsong![index].id!,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Container(
                  height: rheight * 0.08,
                  width: rheight * 0.08,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('asset/images/moosic.jpg'))),
                ),
              ),
            ),
            SizedBox(
              // width: MediaQuery.of(context).size.width * 0.04,
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
                playsong.removeAt(index);
                Provider.of<HomeProvider>(context, listen: false)
                    .viewAllPlaylists();
                Provider.of<HomeProvider>(context, listen: false)
                    .convertPlaylistSongs(playListIndex);
              },
              icon: const Icon(CarbonIcons.music_remove),
              color: Colors.red,
            ),
            const SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
