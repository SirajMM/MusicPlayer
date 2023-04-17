import 'package:blaze_player/model/songmodel.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'playlistmodel.g.dart';

@HiveType(typeId: 2)
class PlayListDb {
  @HiveField(0)
  String? playlistname;
  @HiveField(1)
  List<Songs>? playlistsongs;
  PlayListDb({required this.playlistname, required this.playlistsongs});
}

class PlaylistBox {
  static Box<PlayListDb>? _box;
  static Box<PlayListDb> getInstance() {
    return _box ??= Hive.box('playlist');
  }
}
