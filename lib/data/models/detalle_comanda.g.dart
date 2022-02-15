// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detalle_comanda.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetalleComanda _$DetalleComandaFromJson(Map<String, dynamic> json) {
  return DetalleComanda(
    json['documento'] as String,
    json['nodoc'] as int,
    json['tipodoc'] as String,
    json['referencia'] as String,
    (json['precio'] as num).toDouble(),
    (json['cantidad'] as num).toDouble(),
    DateTime.parse(json['fecha'] as String),
    (json['total'] as num).toDouble(),
    json['producto'] as String,
    json['orden'] as int,
    json['impreso'] as bool,
    (json['itbis'] as num).toDouble(),
    (json['ley'] as num).toDouble(),
    json['silla'] as int,
    json['nota'] as String,
    json['division'] as int,
    json['facturado'] as bool,
    (json['cantidad2'] as num).toDouble(),
    json['conteo'] as int,
    json['comentario'] as String,
    json['despachado'] as bool,
  );
}

Map<String, dynamic> _$DetalleComandaToJson(DetalleComanda instance) =>
    <String, dynamic>{
      'documento': instance.documento,
      'nodoc': instance.nodoc,
      'tipodoc': instance.tipodoc,
      'referencia': instance.referencia,
      'precio': instance.precio,
      'cantidad': instance.cantidad,
      'fecha': instance.fecha.toIso8601String(),
      'total': instance.total,
      'producto': instance.producto,
      'orden': instance.orden,
      'impreso': instance.impreso,
      'itbis': instance.itbis,
      'ley': instance.ley,
      'silla': instance.silla,
      'nota': instance.nota,
      'division': instance.division,
      'facturado': instance.facturado,
      'cantidad2': instance.cantidad2,
      'conteo': instance.conteo,
      'comentario': instance.comentario,
      'despachado': instance.despachado,
    };
