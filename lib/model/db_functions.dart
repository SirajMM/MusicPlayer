import 'package:blaze_player/model/favoritemodel.dart';
import 'package:blaze_player/model/mostlyplayedmodel.dart';
import 'package:blaze_player/model/playlistmodel.dart';
import 'package:blaze_player/model/recentlyplayedmodel.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
// ========= to fetch the lyrics from api =============

Future fetchLyrics(String songName, String artistName) async {
  const apiKey = '1255cecba5b27aad3ef72022b0c74cae';
  final response = await http.get(Uri.parse(
      'https://api.musixmatch.com/ws/1.1/matcher.lyrics.get?apikey=$apiKey&q_track=$songName&q_artist=$artistName'));
  if (response.statusCode == 200) {
    final lyricsResponse = jsonDecode(response.body);
    final lyrics = lyricsResponse['message']['body']['lyrics']['lyrics_body'];
    return lyrics;
  } else {
    const text = Text('Failed to fetch lyrics');
    return text;
  }
}
