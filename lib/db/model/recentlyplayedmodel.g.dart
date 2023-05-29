// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recentlyplayedmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentlyPlayedSongsAdapter extends TypeAdapter<RecentlyPlayedSongs> {
  @override
  final int typeId = 3;

  @override
  RecentlyPlayedSongs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentlyPlayedSongs(
      songname: fields[0] as String?,
      artist: fields[1] as String?,
      duration: fields[2] as int?,
      songurl: fields[3] as String?,
      id: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RecentlyPlayedSongs obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.songname)
      ..writeByte(1)
      ..write(obj.artist)
      ..writeByte(2)
      ..write(obj.duration)
      ..writeByte(3)
      ..write(obj.songurl)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentlyPlayedSongsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
