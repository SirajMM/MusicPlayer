// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import '../../db/model/playlistmodel.dart';
import '../../db/model/songmodel.dart';

class PlayListSongsProvider extends ChangeNotifier {
  List<Songs> playsong = [];
  List<Audio> _plalistSongsConvertAudio = [];
  List<Audio> get plalistSongsConvertAudio => _plalistSongsConvertAudio;
  convertPlaylistSongs(index) {
    final playlistbox = PlaylistBox.getInstance();
    List<PlayListDb> playlistsong = playlistbox.values.toList();
    _plalistSongsConvertAudio.clear();
    for (var element in playlistsong[index].playlistsongs!) {
      _plalistSongsConvertAudio.add(
        Audio.file(
          element.songurl!,
          metas: Metas(
              title: element.songname,
              artist: element.artist,
              id: element.id.toString()),
        ),
      );
    }
    notifyListeners();
  }

  viewPlaylistAllSongs(index) {
    final _playBox = PlaylistBox.getInstance();
    List<PlayListDb> _playlistsong = _playBox.values.toList();
    playsong = _playlistsong[index].playlistsongs!;
    notifyListeners();
  }

  addToPlaylist({index, playListName, playlistindex}) {
    final playbox = PlaylistBox.getInstance();
    PlayListDb? playSongsIndex = playbox.getAt(playlistindex);
    List<Songs> playListsongs = playSongsIndex!.playlistsongs!;
    List<Songs> allSongs = SongBox.getInstance().values.toList();
    bool isThere =
        playListsongs.any((element) => element.id == allSongs[index].id);

    if (!isThere) {
      playListsongs.add(
        Songs(
            songname: allSongs[index].songname,
            artist: allSongs[index].artist,
            duration: allSongs[index].duration,
            songurl: allSongs[index].songurl,
            id: allSongs[index].id),
      );
    } else {
      playListsongs.removeWhere((element) => element.id == allSongs[index].id);
    }
    playbox.putAt(playlistindex,
        PlayListDb(playlistname: playListName, playlistsongs: playListsongs));
    // notifyListeners();
  }
}
