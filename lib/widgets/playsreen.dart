// // ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables, unused_field, must_be_immutable, unnecessary_null_comparison,, non_constant_identifier_names, avoid_types_as_parameter_names

// import 'dart:ui';
// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
// import 'package:blaze_player/model/songmodel.dart';
// import 'package:blaze_player/screens/functions/addtofav.dart';
// import 'package:blaze_player/screens/home_screen.dart';
// import 'package:blaze_player/styles/stile1.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:on_audio_query/on_audio_query.dart';

// // import '../model/db_functions.dart';
// import '../widgets/utlities.dart';

// class PlayScreen extends StatefulWidget {
//   PlayScreen({super.key, this.index});
//   final index;
//   List<Songs>? songs;
//   static int? initialindex = 0;
//   static ValueNotifier<int> currentindex = ValueNotifier<int>(initialindex!);

//   @override
//   State<PlayScreen> createState() => _PlayScreenState();
// }

// final audioplayer2 = AssetsAudioPlayer.withId('0');

// // bool isplaying = false;
// bool isfavorite = false;
// bool isshuffle = false;
// // String _lyrics = '';

// class _PlayScreenState extends State<PlayScreen> {
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   int currentindex = 0;
//   bool isRepeat = false;
//   bool isShuffle = false;

//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           centerTitle: true,
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back_ios),
//             color: textcolor,
//           ),
//           title: Padding(
//             padding: const EdgeInsets.all(.0),
//             child: Text(
//               'Playing',
//               style: headingStyle,
//             ),
//           ),
//           actions: [
//             IconButton(
//                 onPressed: () => getLyrics(context),
//                 icon: const Icon(
//                   Icons.lyrics_outlined,
//                   color: Colors.black,
//                   size: 30,
//                 ))
//           ],
//         ),
//         body: Stack(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 image: DecorationImage(
//                     fit: BoxFit.cover,
//                     image:
//                         AssetImage('asset/images/player background them.webp')),
//               ),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
//                 child: Container(
//                   color: Colors.transparent,
//                 ),
//               ),
//             ),
//             ValueListenableBuilder(
//               valueListenable: PlayScreen.currentindex,
//               builder: (context, value, child) {
//                 return ValueListenableBuilder<Box<Songs>>(
//                   valueListenable: box.listenable(),
//                   builder: ((context, Box<Songs> allsongbox, child) {
//                     List<Songs> allsongs = allsongbox.values.toList();
//                     if (allsongs.isEmpty) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (allsongs == null) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     return audioplayer2.builderCurrent(
//                       builder: (context, playing) {
//                         return Container(
//                           height: size.height,
//                           child: Column(
//                             children: [
//                               Padding(
//                                 padding:
//                                     EdgeInsets.only(top: size.height * 0.16),
//                                 child: Column(
//                                   // mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,

//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(20),
//                                       child: ClipRRect(
//                                         child: QueryArtworkWidget(
//                                           quality: 100,
//                                           keepOldArtwork: true,
//                                           id: int.parse(
//                                               playing.audio.audio.metas.id!),
//                                           type: ArtworkType.AUDIO,
//                                           artworkQuality: FilterQuality.high,
//                                           artworkFit: BoxFit.cover,
//                                           artworkHeight: size.height * 0.36,
//                                           artworkWidth: size.height * 0.36,
//                                           artworkBorder: const BorderRadius.all(
//                                               Radius.circular(10)),
//                                           nullArtworkWidget: Container(
//                                             decoration: const BoxDecoration(
//                                               color: Color.fromARGB(
//                                                   134, 99, 85, 85),
//                                               borderRadius: BorderRadius.all(
//                                                   Radius.circular(20)),
//                                             ),
//                                             child: Image.asset(
//                                               'asset/images/moosic.jpg',
//                                               fit: BoxFit.cover,
//                                               width: size.height * 0.36,
//                                               height: size.height * 0.36,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       height: size.height * 0.03,
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 30, right: 30),
//                                       child: Text(
//                                         audioplayer2.getCurrentAudioTitle,
//                                         style: homeStyle,
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                       ),
//                                     ),
//                                     Padding(
//                                       padding: const EdgeInsets.only(
//                                           left: 30, right: 30),
//                                       child: Text(
//                                         audioplayer2.getCurrentAudioArtist ==
//                                                 '<unknown>'
//                                             ? 'Artist not found'
//                                             : audioplayer2
//                                                 .getCurrentAudioArtist,
//                                         overflow: TextOverflow.ellipsis,
//                                         maxLines: 1,
//                                         textAlign: TextAlign.center,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: size.height * 0.02,
//                               ),
//                               Padding(
//                                 padding: const EdgeInsets.all(15),
//                                 child: Column(
//                                   children: [
//                                     PlayerBuilder.realtimePlayingInfos(
//                                       player: audioplayer2,
//                                       builder: (context, RealtimePlayingInfos) {
//                                         duration = RealtimePlayingInfos
//                                             .current!.audio.duration;
//                                         position = RealtimePlayingInfos
//                                             .currentPosition;

//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                               left: 10, right: 10),
//                                           child: ProgressBar(
//                                             baseBarColor: const Color.fromARGB(
//                                                     255, 217, 193, 193)
//                                                 .withOpacity(0.3),
//                                             progressBarColor: buttoncolor,
//                                             thumbColor: buttoncolor,
//                                             thumbRadius: 5,
//                                             timeLabelPadding: 5,
//                                             progress: position,
//                                             total: duration,
//                                             onSeek: (duration) async {
//                                               await audioPlayer1.seek(duration);
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: size.height * 0.02,
//                               ),
//                               PlayerBuilder.isPlaying(
//                                   player: audioplayer2,
//                                   builder: (context, isPlaying) {
//                                     return Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceAround,
//                                       children: [
//                                         InkWell(
//                                           onTap: () async {
//                                             await audioplayer2.previous();
//                                           },
//                                           child: const Icon(
//                                             Icons.skip_previous,
//                                             size: 35,
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             audioplayer2.seekBy(
//                                                 const Duration(seconds: -10));
//                                           },
//                                           child: const Icon(
//                                             Icons.replay_10,
//                                             size: 35,
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () async {
//                                             if (isPlaying) {
//                                               await audioplayer2.pause();
//                                             } else {
//                                               await audioplayer2.play();
//                                             }

//                                             setState(() {
//                                               isPlaying = !isPlaying;
//                                             });
//                                           },
//                                           child: Icon(
//                                             isPlaying
//                                                 ? Icons.pause_circle
//                                                 : Icons.play_circle,
//                                             size: 35,
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () {
//                                             audioPlayer1.seekBy(
//                                                 const Duration(seconds: 10));
//                                           },
//                                           child: const Icon(
//                                             Icons.forward_10,
//                                             size: 35,
//                                           ),
//                                         ),
//                                         InkWell(
//                                           onTap: () async {
//                                             await audioPlayer1.next();
//                                           },
//                                           child: const Icon(
//                                             Icons.skip_next,
//                                             size: 35,
//                                           ),
//                                         ),
//                                       ],
//                                     );
//                                   }),
//                               SizedBox(
//                                 height: size.height * 0.06,
//                               ),
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: [
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         isShuffle = !isShuffle;
//                                       });
//                                       audioPlayer1.toggleShuffle();
//                                     },
//                                     icon: (isShuffle)
//                                         ? const Icon(
//                                             Icons.shuffle_on_sharp,
//                                             color: Colors.black,
//                                           )
//                                         : const Icon(
//                                             Icons.shuffle,
//                                             color: Colors.black,
//                                           ),
//                                   ),
//                                   IconButton(
//                                     icon: (checkFavourite(
//                                             int.parse(
//                                                 playing.audio.audio.metas.id!),
//                                             BuildContext))
//                                         ? const Icon(
//                                             Icons.favorite_border,
//                                             color: Colors.black,
//                                           )
//                                         : Icon(
//                                             Icons.favorite,
//                                             color: buttoncolor,
//                                           ),
//                                     onPressed: () {
//                                       if (checkFavourite(
//                                           int.parse(
//                                               playing.audio.audio.metas.id!),
//                                           BuildContext)) {
//                                         addToFavorite(int.parse(
//                                             playing.audio.audio.metas.id!));
//                                       } else if (!checkFavourite(
//                                           int.parse(
//                                               playing.audio.audio.metas.id!),
//                                           BuildContext)) {
//                                         removeFav(int.parse(
//                                             playing.audio.audio.metas.id!));
//                                       }
//                                       setState(() {
//                                         checkFavourite(
//                                                 int.parse(playing
//                                                     .audio.audio.metas.id!),
//                                                 BuildContext) !=
//                                             checkFavourite(
//                                                 int.parse(playing
//                                                     .audio.audio.metas.id!),
//                                                 BuildContext);
//                                       });
//                                     },
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       bottomSheet(context, playing.index);
//                                     },
//                                     icon: const Icon(
//                                       Icons.playlist_add,
//                                       color: Colors.black,
//                                       size: 30,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     onPressed: () {
//                                       setState(() {
//                                         if (isRepeat) {
//                                           audioPlayer1
//                                               .setLoopMode(LoopMode.none);
//                                           isRepeat = false;
//                                         } else {
//                                           audioPlayer1
//                                               .setLoopMode(LoopMode.single);
//                                           isRepeat = true;
//                                         }
//                                       });
//                                     },
//                                     icon: Icon(
//                                       (isRepeat)
//                                           ? Icons.repeat_one_outlined
//                                           : Icons.repeat,
//                                       size: 30,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
