import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../../db/functions/db_functions.dart';
import '../../db/model/mostlyplayedmodel.dart';
import '../../db/model/songmodel.dart';
import '../../presentation/main_page/screen_main.dart';

class SplashProvider extends ChangeNotifier {
  final box = SongBox.getInstance();
  List<SongModel> allSongs = [];
  List<SongModel> _getSongs = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final player = AssetsAudioPlayer();
  requestPermission(context) async {
    bool permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();

      _getSongs = await _audioQuery.querySongs();
      for (var element in _getSongs) {
        if (element.fileExtension == 'mp3' || element.fileExtension == 'flac') {
          allSongs.add(element);
        }
      }

      for (var element in allSongs) {
        await box.add(Songs(
            songname: element.title,
            artist: element.artist,
            duration: element.duration,
            songurl: element.uri,
            id: element.id));
      }
      for (var element in allSongs) {
        mostlyplayedboxopen.add(
          MostlyPlayedSongs(
              songname: element.title,
              artist: element.artist,
              duration: element.duration,
              id: element.id,
              songurl: element.uri,
              count: 0),
        );
      }
    }
    await Future.delayed(
      const Duration(seconds: 1),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (ctx) => ScreenMain()),
    );
    notifyListeners();
  }
}
