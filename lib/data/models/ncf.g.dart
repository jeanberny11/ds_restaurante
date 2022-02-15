// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ncf.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ncf _$NcfFromJson(Map<String, dynamic> json) {
  return Ncf(
    json['f_codigo'] as int,
    json['f_descripcion'] as String,
    json['f_visible'] as bool,
  );
}

Map<String, dynamic> _$NcfToJson(Ncf instance) => <String, dynamic>{
      'f_codigo': instance.f_codigo,
      'f_descripcion': instance.f_descripcion,
      'f_visible': instance.f_visible,
    };
