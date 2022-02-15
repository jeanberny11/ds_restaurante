// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mesa _$MesaFromJson(Map<String, dynamic> json) {
  return Mesa(
    json['f_id'] as int,
    json['f_descripcion'] as String?,
    json['f_estado'] as bool?,
    json['f_zonaid'] as int,
  );
}

Map<String, dynamic> _$MesaToJson(Mesa instance) => <String, dynamic>{
      'f_id': instance.f_id,
      'f_descripcion': instance.f_descripcion,
      'f_estado': instance.f_estado,
      'f_zonaid': instance.f_zonaid,
    };
