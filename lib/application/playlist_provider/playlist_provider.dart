import 'package:flutter/material.dart';

import '../../db/model/playlistmodel.dart';

class PlalistProvider extends ChangeNotifier {
  List<PlayListDb> playlistsongdb = [];
  void viewAllPlaylists() {
    playlistsongdb = PlaylistBox.getInstance().values.toList();
    notifyListeners();
  }
}
