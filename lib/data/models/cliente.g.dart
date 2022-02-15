// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cliente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cliente _$ClienteFromJson(Map<String, dynamic> json) {
  return Cliente(
    json['f_id'] as int,
    json['f_nombre'] as String?,
    json['f_apellido'] as String?,
    json['f_telefono'] as String?,
    json['f_balance'] as String,
    json['f_limite_credito'] as String,
    json['f_email'] as String?,
    json['f_facturarcredito'] as bool?,
    json['f_dias_credito'] as String,
    json['f_celular'] as String?,
    json['f_direccion'] as String?,
    json['f_vendedor'] as int,
    json['f_rif'] as String?,
    json['f_exento_impuestos'] as bool,
    json['f_precio_venta'] as int?,
    json['f_activo'] as bool,
    json['f_tipo_comprobante'] as int?,
  );
}

Map<String, dynamic> _$ClienteToJson(Cliente instance) => <String, dynamic>{
      'f_id': instance.f_id,
      'f_nombre': instance.f_nombre,
      'f_apellido': instance.f_apellido,
      'f_telefono': instance.f_telefono,
      'f_balance': instance.f_balance,
      'f_limite_credito': instance.f_limite_credito,
      'f_email': instance.f_email,
      'f_facturarcredito': instance.f_facturarcredito,
      'f_dias_credito': instance.f_dias_credito,
      'f_celular': instance.f_celular,
      'f_direccion': instance.f_direccion,
      'f_vendedor': instance.f_vendedor,
      'f_rif': instance.f_rif,
      'f_exento_impuestos': instance.f_exento_impuestos,
      'f_precio_venta': instance.f_precio_venta,
      'f_activo': instance.f_activo,
      'f_tipo_comprobante': instance.f_tipo_comprobante,
    };
