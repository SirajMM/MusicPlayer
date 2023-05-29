import 'package:hive_flutter/hive_flutter.dart';
part 'recentlyplayedmodel.g.dart';

@HiveType(typeId: 3)
class RecentlyPlayedSongs {
  @HiveField(0)
  String? songname;
  @HiveField(1)
  String? artist;
  @HiveField(2)
  int? duration;
  @HiveField(3)
  String? songurl;
  @HiveField(4)
  int? id;
  RecentlyPlayedSongs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id});
}

class RecentlyPlayedBox {
  static Box<RecentlyPlayedSongs>? _box;
  static Box<RecentlyPlayedSongs> getinstance() {
    return _box ??= Hive.box('Recentlydb');
  }
}
