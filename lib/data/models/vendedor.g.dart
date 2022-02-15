// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendedor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vendedor _$VendedorFromJson(Map<String, dynamic> json) {
  return Vendedor(
    json['f_idvendedor'] as int,
    json['f_nombre'] as String?,
    json['f_apellido'] as String?,
    json['f_telefono1'] as String?,
    json['f_telefono2'] as String?,
    json['f_direccion'] as String?,
    json['f_activo'] as bool?,
    json['f_nombre2'] as String?,
  );
}

Map<String, dynamic> _$VendedorToJson(Vendedor instance) => <String, dynamic>{
      'f_idvendedor': instance.f_idvendedor,
      'f_nombre': instance.f_nombre,
      'f_apellido': instance.f_apellido,
      'f_telefono1': instance.f_telefono1,
      'f_telefono2': instance.f_telefono2,
      'f_direccion': instance.f_direccion,
      'f_activo': instance.f_activo,
      'f_nombre2': instance.f_nombre2,
    };
