// ignore_for_file: sized_box_for_whitespace, unused_element
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/application/homeprovider/home_provider.dart';
import 'package:blaze_player/presentation/home/home_screen.dart';
import 'package:blaze_player/presentation/miniplayer/miniplayer.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

Map isplayingMap = {};

TextEditingController _searchController = TextEditingController();

class _SearchScreenState extends State<SearchScreen> {
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
            child: Consumer<HomeProvider>(builder: (context, value, child) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                Provider.of<HomeProvider>(context, listen: false)
                    .searchConvertAudio;
              });
              return Column(
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
                        Provider.of<HomeProvider>(context, listen: false)
                            .searchsong(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              if (_searchController.text.isEmpty) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .convertAudios
                                    .clear();
                              } else {
                                _searchController.clear();
                                Provider.of<HomeProvider>(context,
                                        listen: false)
                                    .convertAudios
                                    .clear();
                              }
                            }),
                        prefixIcon: const Icon(CupertinoIcons.search),
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
                  value.searchList.isNotEmpty
                      ? ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: Provider.of<HomeProvider>(context)
                              .convertAudios
                              .length,
                          itemBuilder: (context, index) => costemListTile(
                              titile: value.searchList[index].songname,
                              singer: value.searchList[index].artist,
                              index: index,
                              nextlist: value.searchList,
                              context: context),
                          separatorBuilder: (context, index) => SizedBox(
                            height: rheight * 0.01,
                          ),
                        )
                      : Container(
                          height: rwidth * 1,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.network(
                                  'https://assets8.lottiefiles.com/packages/lf20_uqfbsoei.json',
                                  height: rwidth * 0.8),
                              Text(
                                "No match Found!",
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
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}

Widget costemListTile(
    {String? titile, String? singer, nextlist, index, context}) {
  return InkWell(
    onTap: () async {
      FocusManager.instance.primaryFocus?.unfocus();

      await audioPlayer1.open(
          Playlist(
              audios: Provider.of<HomeProvider>(context, listen: false)
                  .searchConvertAudio,
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
          // IconButton(
          //   onPressed: () {
          //     setState(() {
          //       isPlaying = !isPlaying;
          //       isplayingMap[index] = isPlaying;
          //     });
          //     if (isPlaying) {
          //       audioPlayer1.open(
          //           Playlist(
          //               audios:
          //                   Provider.of<HomeProvider>(context).convertAudios,
          //               startIndex: index),
          //           showNotification: true,
          //           headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
          //           loopMode: LoopMode.playlist);
          //       audioPlayer1.play();
          //     } else {
          //       audioPlayer1.pause();
          //     }
          //   },
          //   icon: (isPlaying)
          //       ? const Icon(Icons.pause)
          //       : const Icon(Icons.play_arrow),
          // ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
    ),
  );
}
