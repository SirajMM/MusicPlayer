import 'package:hive_flutter/hive_flutter.dart';
part 'favoritemodel.g.dart';

@HiveType(typeId: 1)
class FavSongs {
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
  FavSongs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.songurl,
      required this.id});
}

class FavBox {
  static Box<FavSongs>? _box;
  static Box<FavSongs> getInstance() {
    return _box ??= Hive.box('favorites');
  }
}
