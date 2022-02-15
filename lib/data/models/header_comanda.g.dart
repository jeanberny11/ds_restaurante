// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_comanda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaderComanda _$HeaderComandaFromJson(Map<String, dynamic> json) {
  return HeaderComanda(
    json['documento'] as String,
    json['nodoc'] as int,
    json['tipodoc'] as String,
    (json['monto'] as num).toDouble(),
    (json['itbis'] as num).toDouble(),
    DateTime.parse(json['fecha'] as String),
    json['usuarioid'] as int,
    json['mesa'] as int,
    json['vendedor'] as int,
    json['cerrado'] as bool,
    json['usuariomodi'] as int,
    (json['descuento'] as num).toDouble(),
    json['clienteid'] as int,
    json['nombrecliente'] as String,
    json['direccion'] as String,
    json['telefono'] as String,
    (json['ley'] as num).toDouble(),
    json['factura'] as String,
    json['nota'] as String,
    (json['delivery'] as num).toDouble(),
    json['separado'] as bool,
    json['rnc'] as String,
  );
}

Map<String, dynamic> _$HeaderComandaToJson(HeaderComanda instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'nodoc': instance.nodoc,
      'tipodoc': instance.tipodoc,
      'monto': instance.monto,
      'itbis': instance.itbis,
      'fecha': instance.fecha.toIso8601String(),
      'usuarioid': instance.usuarioid,
      'mesa': instance.mesa,
      'vendedor': instance.vendedor,
      'cerrado': instance.cerrado,
      'usuariomodi': instance.usuariomodi,
      'descuento': instance.descuento,
      'clienteid': instance.clienteid,
      'nombrecliente': instance.nombrecliente,
      'direccion': instance.direccion,
      'telefono': instance.telefono,
      'ley': instance.ley,
      'factura': instance.factura,
      'nota': instance.nota,
      'delivery': instance.delivery,
      'separado': instance.separado,
      'rnc': instance.rnc,
    };
