// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zonas_mesas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zona _$ZonaFromJson(Map<String, dynamic> json) {
  return Zona(
    json['f_id'] as int,
    json['f_descripcion'] as String?,
    json['f_activo'] as bool?,
  );
}

Map<String, dynamic> _$ZonaToJson(Zona instance) => <String, dynamic>{
      'f_id': instance.f_id,
      'f_descripcion': instance.f_descripcion,
      'f_activo': instance.f_activo,
    };
