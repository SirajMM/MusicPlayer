// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/favoritemodel.dart';
import '../model/mostlyplayedmodel.dart';
import '../model/playlistmodel.dart';
import '../model/recentlyplayedmodel.dart';
import '../model/songmodel.dart';

late Box<FavSongs> favsongsdb;
openFavDb() async {
  favsongsdb = await Hive.openBox<FavSongs>('favorites');
}

late Box<PlayListDb> playlistdb;
openPlaylistDb() async {
  playlistdb = await Hive.openBox<PlayListDb>('playlist');
}

late Box<RecentlyPlayedSongs> recentlyplayedopenbox;
openRecentlyPlayed() async {
  recentlyplayedopenbox = await Hive.openBox('Recentlydb');
}

late Box<MostlyPlayedSongs> mostlyplayedboxopen;
openMostlyBox() async {
  mostlyplayedboxopen = await Hive.openBox<MostlyPlayedSongs>('MostlyPLayedDb');
}

addrecentlyplayed(RecentlyPlayedSongs song) {
  List<RecentlyPlayedSongs> list = recentlyplayedopenbox.values.toList();
  bool notThere =
      list.where((element) => element.songname == song.songname).isEmpty;
  if (notThere) {
    recentlyplayedopenbox.add(song);
  } else {
    int index = list.indexWhere((element) => element.songname == song.songname);
    recentlyplayedopenbox.deleteAt(index);
    recentlyplayedopenbox.add(song);
  }
}

// ========== mostplayed song count =============

addPlayedSongsCount(MostlyPlayedSongs song, int index) {
  final box = MostlyPlayedBox.getInstance();
  List<MostlyPlayedSongs> mostlist = box.values.toList();
  bool notThere =
      mostlist.where((element) => element.songname == song.songname).isEmpty;
  if (notThere) {
    box.add(song);
  } else {
    int index =
        mostlist.indexWhere((element) => element.songname == song.songname);
    box.deleteAt(index);
    box.put(index, song);
    // box.add(song);
  }
  int count = song.count!;
  song.count = count + 1;
}
// =============== Favourite ==================

bool checkFavourite(int? songId, buildContext) {
  List<FavSongs> favouritesongs = [];
  final _box = SongBox.getInstance();
  List<Songs> dbsongs = _box.values.toList();

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

// ============ play list ====================
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
        'That playlist already exist',
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

// ========= to fetch the lyrics from api =============

Future fetchLyrics(String songName, String artistName) async {
  const apiKey = '1255cecba5b27aad3ef72022b0c74cae';
  final response = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=$apiKey&q_track=$songName&q_artist=$artistName'));
  if (response.statusCode == 200 || response.statusCode == 201) {
    final lyricsResponse = jsonDecode(response.body);

    final lyrics = lyricsResponse['message']['body']['lyrics']['lyrics_body'];
    return lyrics;
  } else {
    const text = Text('Failed to fetch lyrics');
    return text;
  }
}

bool checkSongOnplaylist(index, playlistindex) {
  List<Songs> allSongs = SongBox.getInstance().values.toList();
  List<PlayListDb> playlist = PlaylistBox.getInstance().values.toList();
  List<Songs> playlistSongs = playlist[playlistindex].playlistsongs!;

  bool contains = playlistSongs
      .where((element) => element.songname == allSongs[index].songname)
      .isEmpty;
  return contains;
}
