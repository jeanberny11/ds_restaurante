// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Productos _$ProductosFromJson(Map<String, dynamic> json) {
  return Productos(
    json['f_referencia'] as String,
    json['f_descripcion'] as String,
    json['f_controlinventario'] as bool,
    json['f_idcategoria'] as int,
    json['f_maxdescuento'] as String,
    json['f_precio'] as String,
    json['f_precio2'] as String,
    json['f_precio3'] as String,
    json['f_precio4'] as String,
    json['f_precio5'] as String,
    json['f_precio6'] as String,
    json['f_ultimocosto'] as String,
    json['f_tieneitbs'] as bool,
    json['f_referencia_suplidor'] as String?,
    json['f_iddepto'] as int,
    json['f_id_barra'] as String?,
    json['f_idmarca'] as int,
    json['f_oferta'] as bool,
    json['f_impuesto'] as String,
  );
}

Map<String, dynamic> _$ProductosToJson(Productos instance) => <String, dynamic>{
      'f_referencia': instance.f_referencia,
      'f_descripcion': instance.f_descripcion,
      'f_controlinventario': instance.f_controlinventario,
      'f_idcategoria': instance.f_idcategoria,
      'f_maxdescuento': instance.f_maxdescuento,
      'f_precio': instance.f_precio,
      'f_precio2': instance.f_precio2,
      'f_precio3': instance.f_precio3,
      'f_precio4': instance.f_precio4,
      'f_precio5': instance.f_precio5,
      'f_precio6': instance.f_precio6,
      'f_ultimocosto': instance.f_ultimocosto,
      'f_tieneitbs': instance.f_tieneitbs,
      'f_referencia_suplidor': instance.f_referencia_suplidor,
      'f_iddepto': instance.f_iddepto,
      'f_id_barra': instance.f_id_barra,
      'f_idmarca': instance.f_idmarca,
      'f_oferta': instance.f_oferta,
      'f_impuesto': instance.f_impuesto,
    };
