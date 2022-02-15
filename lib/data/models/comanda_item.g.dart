// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comanda_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComandaItem _$ComandaItemFromJson(Map<String, dynamic> json) {
  return ComandaItem(
    json['referencia'] as String,
    json['descripcion'] as String,
    (json['cantidad'] as num).toDouble(),
    (json['precio'] as num).toDouble(),
    (json['costo'] as num).toDouble(),
    json['idcategoria'] as int,
    (json['pimpuesto'] as num).toDouble(),
    (json['montobruto'] as num).toDouble(),
    json['tieneimpuesto'] as bool,
    (json['montoexento'] as num).toDouble(),
    (json['baseimponible'] as num).toDouble(),
    (json['impuesto'] as num).toDouble(),
    (json['pley'] as num).toDouble(),
    (json['ley'] as num).toDouble(),
    (json['total'] as num).toDouble(),
    json['nota'] as String,
    json['orden'] as int,
    json['despachado'] as bool,
    (json['cantidad2'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ComandaItemToJson(ComandaItem instance) =>
    <String, dynamic>{
      'referencia': instance.referencia,
      'descripcion': instance.descripcion,
      'cantidad': instance.cantidad,
      'precio': instance.precio,
      'costo': instance.costo,
      'idcategoria': instance.idcategoria,
      'pimpuesto': instance.pimpuesto,
      'montobruto': instance.montobruto,
      'tieneimpuesto': instance.tieneimpuesto,
      'montoexento': instance.montoexento,
      'baseimponible': instance.baseimponible,
      'impuesto': instance.impuesto,
      'pley': instance.pley,
      'ley': instance.ley,
      'total': instance.total,
      'nota': instance.nota,
      'orden': instance.orden,
      'despachado': instance.despachado,
      'cantidad2': instance.cantidad2,
    };
