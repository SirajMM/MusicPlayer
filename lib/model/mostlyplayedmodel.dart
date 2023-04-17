import 'package:hive_flutter/hive_flutter.dart';
part 'mostlyplayedmodel.g.dart';

@HiveType(typeId: 4)
class MostlyPlayedSongs {
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
  @HiveField(5)
  int? count;
  MostlyPlayedSongs(
      {required this.songname,
      required this.artist,
      required this.duration,
      required this.id,
      required this.songurl,
      required this.count});
}

class MostlyPlayedBox {
  static Box<MostlyPlayedSongs>? _box;
  static Box<MostlyPlayedSongs> getInstance() {
    return _box ??= Hive.box('MostlyPLayedDb');
  }
}
