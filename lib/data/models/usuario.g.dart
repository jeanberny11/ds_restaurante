// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) {
  return Usuario(
    json['f_codigo_usuario'] as int,
    json['f_apellido'] as String?,
    json['f_nombre'] as String?,
    json['f_direccion'] as String?,
    json['f_telefono'] as String?,
    json['f_email'] as String?,
    json['f_id_usuario'] as String?,
    json['f_sucursal'] as int?,
    json['f_cambiar_precio'] as bool?,
    json['f_descuento'] as bool?,
    json['f_mesa'] as int?,
    json['f_activo'] as bool?,
    json['f_cajero'] as bool?,
    json['f_id_clave'] as int?,
    json['f_camarero'] as bool?,
    json['f_id_empleado'] as int?,
    json['f_departamento'] as int?,
    json['f_vendedor'] as int,
  );
}

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
      'f_codigo_usuario': instance.f_codigo_usuario,
      'f_apellido': instance.f_apellido,
      'f_nombre': instance.f_nombre,
      'f_direccion': instance.f_direccion,
      'f_telefono': instance.f_telefono,
      'f_email': instance.f_email,
      'f_id_usuario': instance.f_id_usuario,
      'f_sucursal': instance.f_sucursal,
      'f_cambiar_precio': instance.f_cambiar_precio,
      'f_descuento': instance.f_descuento,
      'f_mesa': instance.f_mesa,
      'f_activo': instance.f_activo,
      'f_cajero': instance.f_cajero,
      'f_id_clave': instance.f_id_clave,
      'f_camarero': instance.f_camarero,
      'f_id_empleado': instance.f_id_empleado,
      'f_departamento': instance.f_departamento,
      'f_vendedor': instance.f_vendedor,
    };
