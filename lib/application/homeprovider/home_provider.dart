// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers
import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:blaze_player/styles/stile1.dart';
import 'package:flutter/material.dart';
import '../../db/functions/db_functions.dart';
import '../../db/model/favoritemodel.dart';
import '../../db/model/mostlyplayedmodel.dart';
import '../../db/model/recentlyplayedmodel.dart';
import '../../db/model/songmodel.dart';
import '../../presentation/home/home_screen.dart';

class HomeProvider extends ChangeNotifier {
  List<Audio> _convertAudios = [];
  bool _isShuffle = false;
  final _box = MostlyPlayedBox.getInstance();

  List<Songs> allSongs = [];
  List<Songs> searchList = [];

  List<Audio> _mostconvertedaudio = [];
  List<Audio> searchConvertAudio = [];
  List<MostlyPlayedSongs> _mostplayedsongs = [];
  List<Audio> _recentAudio = [];
  List<Audio> _favsongs = [];
  List<FavSongs> _favorites = [];
  List<RecentlyPlayedSongs> _recentsongs = [];
  List<Songs>? dbsongs;

  List<RecentlyPlayedSongs> get recentsongs => _recentsongs;
  List<MostlyPlayedSongs> get mostplayedsongs => _mostplayedsongs;
  List<Audio> get mostconvertedaudio => _mostconvertedaudio;
  List<Audio> get convertAudios => _convertAudios;
  List<Audio> get recentAudio => _recentAudio;
  List<FavSongs> get favorites => _favorites;
  List<Audio> get favsongs => _favsongs;

  get isShuffle => _isShuffle;

  void isSongPlaying(int index) {
    // ignore: prefer_typing_uninitialized_variables
    var currentSongPath;

    // ignore: unnecessary_null_comparison
    if (currentSongPath != null) {
      audioPlayer1.stop();
    }
    audioPlayer1.open(Playlist(audios: _convertAudios, startIndex: index),
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
        showNotification: true,
        loopMode: LoopMode.playlist);
    audioPlayer1.play();
    currentSongPath = _convertAudios[index];
    notifyListeners();
  }

  void shuffle() {
    _isShuffle = !_isShuffle;
    notifyListeners();
  }

  void mostPlayedConvertAudio() {
    List<MostlyPlayedSongs> mostsong = _box.values.toList();
    int count = 0;
    _mostplayedsongs.clear();
    mostsong.sort((a, b) => b.count!.compareTo(a.count!));
    for (var element in mostsong) {
      if (element.count! > 2) {
        _mostplayedsongs.insert(count, element);
        count++;
      }
    }
    for (var element in _mostplayedsongs) {
      _mostconvertedaudio.add(Audio.file(
        element.songurl!,
        metas: Metas(
          title: element.songname,
          artist: element.artist,
          id: element.id.toString(),
        ),
      ));
    }
  }

  void recentSongdstoAudio() {
    final _recentbox = RecentlyPlayedBox.getinstance();
    _recentsongs = _recentbox.values.toList().reversed.toList();
    for (var element in _recentsongs) {
      _recentAudio.add(
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
    notifyListeners();
  }

  void allsSongsAudioadd() {
    log('hahaha');
    List<Songs> _dbsogs = SongBox.getInstance().values.toList();
    for (var element in _dbsogs) {
      _convertAudios.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
            title: element.songname,
            artist: element.artist,
            id: element.id.toString(),
          ),
        ),
      );
    }
  }

  void favConvertAudio() {
    _favorites = FavBox.getInstance().values.toList().reversed.toList();
    _favsongs.clear();

    for (var element in _favorites) {
      _favsongs.add(
        Audio.file(
          element.songurl.toString(),
          metas: Metas(
            artist: element.artist!,
            title: element.songname,
            id: element.id.toString(),
          ),
        ),
      );
    }
    notifyListeners();
  }

  void addToFavorite(int id, context) async {
    ScaffoldMessenger.of(context).clearSnackBars();
    List<Songs> _dbSongs = SongBox.getInstance().values.toList();

    List<FavSongs> favoritesongs = favsongsdb.values.toList();
    bool isPresent = favoritesongs.any((element) => element.id == id);

    if (!isPresent) {
      Songs song = _dbSongs.firstWhere((element) => element.id == id);
      favsongsdb.add(FavSongs(
          songname: song.songname,
          artist: song.artist,
          duration: song.duration,
          songurl: song.songurl,
          id: song.id));
      final snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: const Duration(milliseconds: 500),
          content: Row(
            children: [
              const Text('Added To Favourite'),
              const SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite,
                color: buttoncolor,
              )
            ],
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      int currentindex =
          favoritesongs.indexWhere((element) => element.id == id);
      await favsongsdb.deleteAt(currentindex);
      const snackBar = SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 30,
          duration: Duration(milliseconds: 500),
          content: Row(
            children: [
              Text(' Removed From Favourite'),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
              )
            ],
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    notifyListeners();
  }

  void serchConvertAudio() {
    allSongs = SongBox.getInstance().values.toList();
    searchList = List<Songs>.from(allSongs);
    for (var element in searchList) {
      searchConvertAudio.add(Audio.file(
        element.songurl.toString(),
        metas: Metas(
          artist: element.artist,
          title: element.songname,
          id: element.id.toString(),
        ),
      ));
    }
    notifyListeners();
  }

  void searchsong(value) {
    searchConvertAudio.clear();

    searchList.clear();
    searchList = allSongs
        .where((element) => element.songname!
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
        .toList();

    for (var element in searchList) {
      searchConvertAudio.add(Audio.file(
        element.songurl.toString(),
        metas: Metas(
          artist: element.artist,
          title: element.songname,
          id: element.id.toString(),
        ),
      ));
    }
    notifyListeners();
  }
}
