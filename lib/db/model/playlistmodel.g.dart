// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlistmodel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayListDbAdapter extends TypeAdapter<PlayListDb> {
  @override
  final int typeId = 2;

  @override
  PlayListDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayListDb(
      playlistname: fields[0] as String?,
      playlistsongs: (fields[1] as List?)?.cast<Songs>(),
    );
  }

  @override
  void write(BinaryWriter writer, PlayListDb obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.playlistname)
      ..writeByte(1)
      ..write(obj.playlistsongs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayListDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
