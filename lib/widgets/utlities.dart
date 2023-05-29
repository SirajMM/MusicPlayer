import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:blaze_player/presentation/home/home_screen.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import '../db/functions/db_functions.dart';
import '../db/model/playlistmodel.dart';
import '../db/model/songmodel.dart';
import '../styles/stile1.dart';

// ================== Settings About ====================
Widget about() {
  return Text(
    '''
About Us : 

We are a team of passionate music lovers who have come together to create a better music listening experience for you. Our app is designed to make it easy for you to discover new music, create personalized playlists, and enjoy your favorite tracks anytime, anywhere.

We believe in the power of music to bring people together, and we strive to create a welcoming and inclusive community for music fans of all kinds. We are constantly working to improve the app and add new features to enhance your listening experience.

Thank you for choosing 'Blaze Player' as your go-to music player. We hope you enjoy using it as much as we enjoyed creating it. If you have any feedback or suggestions, we would love to hear from you. Contact us at sirajmuhammed718@gmail.com.

''',
    style: GoogleFonts.raleway(
      textStyle: const TextStyle(
          letterSpacing: .5,
          fontSize: 15,
          fontWeight: FontWeight.normal,
          color: Colors.black),
    ),
  );
}

// =============== Home Recect And Most card ================
Widget buildcard(heading, cover, size) => Stack(children: [
      Container(
        width: size.width * 0.44,
        height: 155,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(cover)),
          boxShadow: const [
            BoxShadow(
              blurRadius: 1.0,
            ),
          ],
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
      ),
      Positioned(
        bottom: 0,
        child: BlurryContainer(
          padding: const EdgeInsets.all(0),
          width: size.width * 0.44,
          height: size.height * 0.04,
          blur: 20,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: Text(
            heading,
            textAlign: TextAlign.center,
            style: songnamestyle,
          ),
        ),
      ),
    ]);

Widget playList(
    String? title, String? subtitle, String? cover, int? index, context) {
  var size = MediaQuery.of(context).size;
  return Container(
    padding: const EdgeInsets.all(8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: size.height * 0.085,
          width: size.width * 0.18,
          decoration: BoxDecoration(
              image:
                  DecorationImage(image: AssetImage(cover!), fit: BoxFit.cover),
              borderRadius: const BorderRadius.all(Radius.circular(15))),
        ),
        SizedBox(
          width: size.width * 0.04,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: homeStyle,
                  ),
                  Text(subtitle!)
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

// =============== Add to Playlist bottomsheet =================
bottomSheet(BuildContext ctx1, songindex) {
  final playlistbox = PlaylistBox.getInstance();
  final songbox = SongBox.getInstance();
  showModalBottomSheet<void>(
    context: ctx1,
    builder: (BuildContext context) {
      return SizedBox(
        // ignore: avoid_unnecessary_containers
        child: SingleChildScrollView(
          child: ValueListenableBuilder<Box<PlayListDb>>(
            valueListenable: playlistbox.listenable(),
            builder: (context, playlistsongs, child) {
              List<PlayListDb> playlistsongdb = playlistsongs.values.toList();
              return Container(
                child: playlistsongdb.isNotEmpty
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              'Your Playlists',
                              style: homeStyle,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: playlistsongdb.length,
                              itemBuilder: (context, index) => InkWell(
                                onTap: () {
                                  PlayListDb? playsongs =
                                      playlistsongs.getAt(index);
                                  List<Songs> playsongdb =
                                      playsongs!.playlistsongs!;
                                  List<Songs> songdb = songbox.values.toList();
                                  bool isThere = playsongdb.any((element) =>
                                      element.id == songdb[songindex].id);
                                  if (!isThere) {
                                    playsongdb.add(
                                      Songs(
                                          songname: songdb[songindex].songname,
                                          artist: songdb[songindex].artist,
                                          duration: songdb[songindex].duration,
                                          songurl: songdb[songindex].songurl,
                                          id: songdb[songindex].id),
                                    );
                                  }
                                  playlistsongs.putAt(
                                      index,
                                      PlayListDb(
                                          playlistname: playlistsongdb[index]
                                              .playlistname,
                                          playlistsongs: playsongdb));
                                  Navigator.pop(context);
                                  const snackBar = SnackBar(
                                    content: Text('Song Added'),
                                    dismissDirection: DismissDirection.down,
                                    behavior: SnackBarBehavior.floating,
                                    elevation: 30,
                                    duration: Duration(milliseconds: 500),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                },
                                child: playList(
                                    playlistsongdb[index].playlistname,
                                    '${playlistsongdb[index].playlistsongs!.length} Songs',
                                    'asset/images/pop.png',
                                    index,
                                    context),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'Create Playlist',
                              style: headingStyle,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.cancel),
                                  label: const Text('Cancel'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttoncolor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    createPlaylistDialogebox(context);
                                  },
                                  icon: const Icon(Icons.create),
                                  label: const Text('Create'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: buttoncolor,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 12),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
              );
            },
          ),
        ),
      );
    },
  );
}

// allSongsSheet(BuildContext ctx1, listindex) {
//   final songbox = SongBox.getInstance();
//   Widget costemListTile(
//       {String? titile,
//       String? singer,
//       Widget? cover,
//       index,
//       playingitem,
//       context}) {
//     Map isplayingMap = {};
//     bool isPlaying = isplayingMap[index] ?? false;
//     return InkWell(
//       child: BlurryContainer(
//         // ignore: prefer_const_constructors
//         color: Color.fromARGB(11, 58, 13, 219),

//         blur: 100,
//         borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height * 0.08,
//               width: MediaQuery.of(context).size.height * 0.08,
//               child: cover,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.03,
//             ),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     titile!,
//                     style: songnamestyle,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.01,
//                   ),
//                   Text(
//                     singer!,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             IconButton(
//                 onPressed: () {
//                   // addToPlaylist(index, listindex);
//                 },
//                 icon: Icon(isPlaying ? Icons.remove : Icons.add)),
//             const SizedBox(
//               width: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   showModalBottomSheet<void>(
//     context: ctx1,
//     builder: (BuildContext context) {
//       return Padding(
//         padding: const EdgeInsets.only(
//           top: 22,
//         ),
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           child: ValueListenableBuilder<Box<Songs>>(
//             valueListenable: songbox.listenable(),
//             builder: (context, allsongbox, child) {
//               List<Songs> allDbSongs = allsongbox.values.toList();
//               var size = MediaQuery.of(context).size;
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       'All Songs',
//                       style: homeStyle,
//                     ),
//                   ),
//                   ListView.separated(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) => costemListTile(
//                             context: context,
//                             playingitem: allDbSongs[index],
//                             index: index,
//                             singer: allDbSongs[index].artist,
//                             titile: allDbSongs[index].songname,
//                             cover: ClipRect(
//                               child: QueryArtworkWidget(
//                                   nullArtworkWidget: Image.asset(
//                                       'asset/images/logon-removebg-preview.png'),
//                                   artworkBorder: const BorderRadius.all(
//                                       Radius.circular(16)),
//                                   artworkHeight: size.height * 0.08,
//                                   artworkWidth: size.height * 0.08,
//                                   artworkFit: BoxFit.contain,
//                                   id: allDbSongs[index].id!,
//                                   type: ArtworkType.AUDIO),
//                             ),
//                             //         );
//                           ),
//                       separatorBuilder: (context, index) => const SizedBox(
//                             height: 10,
//                           ),
//                       itemCount: allDbSongs.length)
//                 ],
//               );
//             },
//           ),
//         ),
//       );
//     },
//   );
// }

// ============= Playlist dialogebox ===================
final TextEditingController textcontroller = TextEditingController();
createPlaylistDialogebox(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Create Playlist'),
      content: TextFormField(
        controller: textcontroller,
        validator: (value) {
          if (value?.trim().isEmpty ?? true) {
            return 'Please enter a name for the playlist';
          }
          return null;
        },
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'\s')),
        ],
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'Enter the name of the playlist',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(
            'Cancel',
            style: TextStyle(color: buttoncolor),
          ),
        ),
        TextButton(
          onPressed: () {
            // ignore: unnecessary_null_comparison
            if (textcontroller.text.isEmpty || textcontroller.text == null) {
              Navigator.pop(context);
              AnimatedSnackBar.material(
                'Name required',
                duration: const Duration(seconds: 1),
                type: AnimatedSnackBarType.error,
              ).show(context);
            } else {
              createplaylist(textcontroller.text.trim(), context);
              Navigator.pop(context, 'Create');
              textcontroller.clear();
            }
          },
          child: Text(
            'Create',
            style: TextStyle(color: textcolor),
          ),
        ),
      ],
    ),
  );
}

// ================= get the song lyrics =================
void getLyrics(context) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        backgroundColor: Colors.black.withOpacity(.7),
        contentTextStyle: const TextStyle(color: Colors.white),
        content: FutureBuilder(
          future: fetchLyrics(audioPlayer1.getCurrentAudioTitle,
              audioPlayer1.getCurrentAudioArtist),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(snapshot.data!),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
                child: const Center(
                  child: Text(
                    'Failed to load lyrics',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              );
            } else {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.red,
                  ),
                ),
              );
            }
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ]),
  );
}
 // endDrawer: 
        // ),