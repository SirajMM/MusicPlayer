import 'package:blaze_player/model/playlistmodel.dart';
import 'package:blaze_player/model/songmodel.dart';
import 'package:flutter/material.dart';

createplaylist(String name, BuildContext context) async {
  final playsbox = PlaylistBox.getInstance();
  List<Songs> songsplaylist = [];

  List<PlayListDb> list = playsbox.values.toList();
  bool isnotpresent =
      list.where((element) => element.playlistname == name).isEmpty;
  if (isnotpresent) {
    playsbox.add(PlayListDb(playlistname: name, playlistsongs: songsplaylist));
  } else {
    const snackbar = SnackBar(
      content: Text(
        'That playlist alredy precent',
      ),
      dismissDirection: DismissDirection.down,
      behavior: SnackBarBehavior.floating,
      elevation: 30,
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}

deleteplaylist(int index) async {
  final playsbox = PlaylistBox.getInstance();
  playsbox.deleteAt(index);
}

editeplaylist(int index, String name) async {
  final playbox = PlaylistBox.getInstance();
  List<PlayListDb> playlistsong = playbox.values.toList();
  final playbox2 = PlaylistBox.getInstance();
  playbox2.putAt(
      index,
      PlayListDb(
          playlistname: name,
          playlistsongs: playlistsong[index].playlistsongs));
}

addToPlaylist(int index, playlistsongs) {
  final songbox = SongBox.getInstance();
  final playbox = PlaylistBox.getInstance();
  // final playbox1 = PlaylistBox.getInstance();

  // List<PlayListDb> playlistdb = playbox1.values.toList();
  PlayListDb? playsongs = playbox.getAt(index);
  List<Songs> playsongdb = playsongs!.playlistsongs!;
  List<Songs> songdb = songbox.values.toList();
  bool isThere = playsongdb.any((element) => element.id == songdb[index].id);

  if (!isThere) {
    playsongdb.add(
      Songs(
          songname: songdb[index].songname,
          artist: songdb[index].artist,
          duration: songdb[index].duration,
          songurl: songdb[index].songurl,
          id: songdb[index].id),
    );
  }
  playbox.putAt(index,
      PlayListDb(playlistname: playlistsongs, playlistsongs: playsongdb));
}
