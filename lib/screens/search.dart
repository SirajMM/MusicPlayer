// ignore_for_file: sized_box_for_whitespace

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/model/songmodel.dart';
import 'package:blaze_player/screens/home_screen.dart';
import 'package:blaze_player/screens/miniplayer.dart';
// import 'package:blaze_player/screens/playsreen.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

Map isplayingMap = {};

TextEditingController _searchController = TextEditingController();
List<Audio> convertAudios = [];

final box = SongBox.getInstance();
late List<Songs> dbsongs;
final songbox = SongBox.getInstance();
List<Songs> nextlist = List.from(dbsongs);

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    dbsongs = songbox.values.toList();
    // for (var element in dbsongs) {
    //   convertAudios.add(
    //     Audio.file(
    //       element.songurl!,
    //       metas: Metas(
    //         title: element.songname,
    //         artist: element.artist,
    //         id: element.id.toString(),
    //       ),
    //     ),
    //   );
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var rheight = MediaQuery.of(context).size.height;
    var rwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: rheight,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Search',
                    style: headingStyle,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(40)),
                  width: rwidth * 0.8,
                  height: rheight * 0.07,
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      searchsong(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            if (_searchController.text.isEmpty) {
                              FocusManager.instance.primaryFocus?.unfocus();
                              convertAudios.clear();
                              setState(() {});
                            } else {
                              _searchController.clear();
                              convertAudios.clear();
                              setState(() {});
                            }
                          }),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 24, 13, 13)),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: rheight * 0.02,
                ),
                SizedBox(
                  height: rheight * 0.02,
                ),
                nextlist.isNotEmpty
                    ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: convertAudios.length,
                        itemBuilder: (context, index) => costemListTile(
                          titile: nextlist[index].songname,
                          singer: nextlist[index].artist,
                          index: index,
                          nextlist: nextlist,
                        ),
                        separatorBuilder: (context, index) => SizedBox(
                          height: rheight * 0.01,
                        ),
                      )
                    : const Center(
                        child: Text('No match found'),
                      )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: const MiniPlayer(),
    );
  }

  searchsong(value) {
    setState(
      () {
        nextlist = dbsongs
            .where((element) => element.songname!
                .toLowerCase()
                .contains((value.toString().toLowerCase())))
            .toList();
        convertAudios.clear();
        for (var element in nextlist) {
          convertAudios.add(
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
      },
    );
  }

  Widget costemListTile({
    String? titile,
    String? singer,
    nextlist,
    index,
  }) {
    bool isPlaying = isplayingMap[index] ?? false;
    return InkWell(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        // PlayScreen.currentindex.value = index!;
        await audioPlayer1.open(
            Playlist(audios: convertAudios, startIndex: index),
            headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
            showNotification: true,
            loopMode: LoopMode.playlist);
        // ignore: use_build_context_synchronously
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
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.height * 0.08,
              decoration: BoxDecoration(
                  border: Border.all(width: .5),
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: QueryArtworkWidget(
                  artworkHeight: MediaQuery.of(context).size.height * 0.08,
                  artworkWidth: MediaQuery.of(context).size.height * 0.08,
                  artworkBorder: const BorderRadius.all(Radius.circular(15)),
                  artworkFit: BoxFit.fill,
                  id: nextlist[index].id!,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Container(
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.height * 0.08,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage('asset/images/moosic.jpg'))),
                  )),
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
                setState(() {
                  isPlaying = !isPlaying;
                  isplayingMap[index] = isPlaying;
                });
                if (isPlaying) {
                  audioPlayer1.open(
                      Playlist(audios: convertAudios, startIndex: index),
                      showNotification: true,
                      headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                      loopMode: LoopMode.playlist);
                  audioPlayer1.play();
                } else {
                  audioPlayer1.pause();
                }
              },
              icon: (isPlaying)
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow),
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
