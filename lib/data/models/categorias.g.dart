// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categorias.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Categorias _$CategoriasFromJson(Map<String, dynamic> json) {
  return Categorias(
    json['f_idcategoria'] as int,
    json['f_descripcion'] as String,
    json['f_visible_factura'] as bool,
  );
}

Map<String, dynamic> _$CategoriasToJson(Categorias instance) =>
    <String, dynamic>{
      'f_idcategoria': instance.f_idcategoria,
      'f_descripcion': instance.f_descripcion,
      'f_visible_factura': instance.f_visible_factura,
    };
