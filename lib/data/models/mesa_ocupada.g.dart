// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mesa_ocupada.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MesaOcupada _$MesaOcupadaFromJson(Map<String, dynamic> json) {
  return MesaOcupada(
    json['f_documento'] as String,
    json['f_mesa'] as int,
    json['f_monto'] as String,
    json['f_nombre_cliente'] as String?,
    json['f_direccion'] as String?,
    json['f_vendedor'] as int,
    json['mesa'] as String,
    json['camarero'] as String,
    (json['hora'] as num).toDouble(),
    (json['minuto'] as num).toDouble(),
  );
}

Map<String, dynamic> _$MesaOcupadaToJson(MesaOcupada instance) =>
    <String, dynamic>{
      'f_documento': instance.f_documento,
      'f_mesa': instance.f_mesa,
      'f_monto': instance.f_monto,
      'f_nombre_cliente': instance.f_nombre_cliente,
      'f_direccion': instance.f_direccion,
      'f_vendedor': instance.f_vendedor,
      'mesa': instance.mesa,
      'camarero': instance.camarero,
      'hora': instance.hora,
      'minuto': instance.minuto,
    };
