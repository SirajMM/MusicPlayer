// ignore_for_file: must_be_immutable, unused_local_variable, sized_box_for_whitespace
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/playlistmodel.dart';
import 'package:blaze_player/model/songmodel.dart';
// import 'package:blaze_player/screens/playsreen.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'miniplayer.dart';

class PlaylistSongs extends StatefulWidget {
  PlaylistSongs(
      {super.key, required this.songindex, required this.playlistname});
  int? songindex;
  String? playlistname;

  @override
  State<PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<PlaylistSongs> {
  final AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.withId('0');
  List<Audio> convertAudio = [];
  final playbox = PlaylistBox.getInstance();

  @override
  void initState() {
    final playlistbox = PlaylistBox.getInstance();
    List<PlayListDb> playlistsong = playlistbox.values.toList();
    for (var element in playlistsong[widget.songindex!].playlistsongs!) {
      convertAudio.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
              title: element.songname,
              artist: element.artist,
              id: element.id.toString()),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double rheight = MediaQuery.of(context).size.height;
    List<PlayListDb> playlistsong = playbox.values.toList();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new)),
        title: Text(
          // 'Playlist ${widget.songindex! + 1}',
          playlistsong[widget.songindex!].playlistname!,
          style: headingStyle,
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: rheight,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ValueListenableBuilder(
                    valueListenable: playbox.listenable(),
                    builder: (context, playlistsongs, child) {
                      List<PlayListDb> playlistsong =
                          playlistsongs.values.toList();
                      List<Songs> playsong =
                          playlistsong[widget.songindex!].playlistsongs!;
                      return playsong.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemCount: playsong.length,
                              itemBuilder: (context, index) => costemListTile(
                                  titile: playsong[index].songname!,
                                  singer: playsong[index].artist,
                                  index: index,
                                  playsong: playsong,
                                  playlistsong: playlistsong),
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
                              )));
                    }),
              ],
            ),
          ),
        ),
      ),
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

  Widget costemListTile(
      {String? titile,
      String? singer,
      index,
      List<Songs>? playsong,
      List? playlistsong}) {
    // final playbox = PlaylistBox.getInstance();
    final rheight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: () {
        // PlayScreen.currentindex.value = index!;
        audioPlayer.open(Playlist(audios: convertAudio, startIndex: index),
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
                  audioPlayer
                      .open(Playlist(audios: convertAudio, startIndex: index));
                },
                icon: const Icon(Icons.play_arrow)),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Row(
                    children: const [
                      Icon(Icons.delete_outline),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Delete'),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 1:
                    setState(() {
                      playsong.removeAt(index);
                      playlistsong!.removeAt(widget.songindex!);
                    });
                    // playbox.putAt(
                    //     widget.songindex!,
                    //     PlayListDb(
                    //         playlistname: widget.playlistname,
                    //         playlistsongs: playsong));

                    Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                            pageBuilder: (context, animation,
                                    secondaryAnimation) =>
                                PlaylistSongs(
                                    songindex: widget.songindex,
                                    playlistname: widget.playlistname),
                            transitionDuration: Duration.zero));

                    break;
                }
              },
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
