// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_model.dart';

class AnalyticsModelAdapter extends TypeAdapter<AnalyticsModel> {
  @override
  final int typeId = 2;

  @override
  AnalyticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AnalyticsModel(
      id: fields[0] as String,
      timestamp: fields[1] as DateTime,
      resultado: fields[2] as String,
      cantidadSesgos: fields[3] as int,
      tiposSesgos: (fields[4] as List).cast<String>(),
      tieneDistorsion: fields[5] as bool,
      sentimiento: fields[6] as String,
      sentimientoScore: fields[7] as double,
      cantidadCoincidencias: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, AnalyticsModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.timestamp)
      ..writeByte(2)
      ..write(obj.resultado)
      ..writeByte(3)
      ..write(obj.cantidadSesgos)
      ..writeByte(4)
      ..write(obj.tiposSesgos)
      ..writeByte(5)
      ..write(obj.tieneDistorsion)
      ..writeByte(6)
      ..write(obj.sentimiento)
      ..writeByte(7)
      ..write(obj.sentimientoScore)
      ..writeByte(8)
      ..write(obj.cantidadCoincidencias);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnalyticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}