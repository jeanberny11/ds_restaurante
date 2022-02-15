// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferencia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferencia _$PreferenciaFromJson(Map<String, dynamic> json) {
  return Preferencia(
    json['f_ley'] as String,
    json['f_itbis_incluido'] as bool,
  );
}

Map<String, dynamic> _$PreferenciaToJson(Preferencia instance) =>
    <String, dynamic>{
      'f_ley': instance.f_ley,
      'f_itbis_incluido': instance.f_itbis_incluido,
    };
