// ignore_for_file: non_constant_identifier_names, avoid_types_as_parameter_names

import 'package:blaze_player/model/db_functions.dart';
import 'package:blaze_player/model/favoritemodel.dart';
import 'package:blaze_player/model/songmodel.dart';
import 'package:blaze_player/screens/splash_screen.dart';
import 'package:flutter/material.dart';

// addToFavorite(int index) async {
//   List<Songs> dbSongs = box.values.toList();
//   List<FavSongs> favoritesongs = [];
//   favoritesongs = favsongsdb.values.toList();
//   bool isempty = favoritesongs
//       .where((element) => element.songname == dbSongs[index].songname)
//       .isEmpty;
//   if (isempty) {
//     favsongsdb.add(FavSongs(
//         songname: dbsongs[index].songname,
//         artist: dbSongs[index].artist,
//         duration: dbSongs[index].duration,
//         songurl: dbSongs[index].songurl,
//         id: dbSongs[index].id));
//   } else {
//     favoritesongs
//         .where((element) => element.songname == dbSongs[index].songname)
//         .isEmpty;
//     int currentindex =
//         favoritesongs.indexWhere((element) => element.id == dbSongs[index].id);
//     await favsongsdb.deleteAt(currentindex);
//   }
// }
addToFavorite(int id) async {
  List<Songs> dbSongs = box.values.toList();
  List<FavSongs> favoritesongs = favsongsdb.values.toList();
  bool isPresent = favoritesongs.any((element) => element.id == id);

  if (!isPresent) {
    Songs song = dbSongs.firstWhere((element) => element.id == id);
    favsongsdb.add(FavSongs(
        songname: song.songname,
        artist: song.artist,
        duration: song.duration,
        songurl: song.songurl,
        id: song.id));
  } else {
    int currentindex = favoritesongs.indexWhere((element) => element.id == id);
    await favsongsdb.deleteAt(currentindex);
  }
}

// bool checkFavourite(int index, BuildContext) {
//   List<FavSongs> favouritesongs = [];
//   List<Songs> dbsongs = box.values.toList();

//   FavSongs value = FavSongs(
//       songname: dbsongs[index].songname,
//       artist: dbsongs[index].artist,
//       duration: dbsongs[index].duration,
//       songurl: dbsongs[index].songurl,
//       id: dbsongs[index].id);

//   favouritesongs = favsongsdb.values.toList();
//   bool ispresent = favouritesongs
//       .where((element) => element.songname == value.songname)
//       .isEmpty;
//   return ispresent ? true : false;
// }
bool checkFavourite(int? songId, BuildContext) {
  List<FavSongs> favouritesongs = [];
  List<Songs> dbsongs = box.values.toList();

  Songs song = dbsongs.firstWhere((element) => element.id == songId);

  FavSongs value = FavSongs(
      songname: song.songname,
      artist: song.artist,
      duration: song.duration,
      songurl: song.songurl,
      id: song.id);

  favouritesongs = favsongsdb.values.toList();
  bool isPresent =
      favouritesongs.where((element) => element.id == value.id).isEmpty;
  return isPresent;
}

// removeFav(int index) async {
//   final favbox = FavBox.getInstance();
//   List<FavSongs> favsongs = favbox.values.toList();
//   List<Songs> dbsongs = box.values.toList();
//   int currentindex =
//       favsongs.indexWhere((element) => element.id == dbsongs[index].id);
//   await favsongsdb.deleteAt(currentindex);
// }
Future<void> removeFav(int songId) async {
  final favbox = FavBox.getInstance();
  List<FavSongs> favsongs = favbox.values.toList();
  int currentindex = favsongs.indexWhere((element) => element.id == songId);
  if (currentindex >= 0) {
    await favsongsdb.deleteAt(currentindex);
  }
}

deletefav(int index, BuildContext context) async {
  await favsongsdb.deleteAt(favsongsdb.length - index - 1);
  // Navigator.push(
  //     context,
  //     PageRouteBuilder(
  //       pageBuilder: (context, animation1, animation2) => FavScreen(),
  //       transitionDuration: Duration.zero,
  //       reverseTransitionDuration: Duration.zero,
  //     ));
}
