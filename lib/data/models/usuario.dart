// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@JsonSerializable()
class Usuario extends Equatable {
  final int f_codigo_usuario;
  final String? f_apellido;
  final String? f_nombre;
  final String? f_direccion;
  final String? f_telefono;
  final String? f_email;
  final String? f_id_usuario;
  final int? f_sucursal;
  final bool? f_cambiar_precio;
  final bool? f_descuento;
  final int? f_mesa;
  final bool? f_activo;
  final bool? f_cajero;
  final int? f_id_clave;
  final bool? f_camarero;
  final int? f_id_empleado;
  final int? f_departamento;
  final int f_vendedor;

  const Usuario(
      this.f_codigo_usuario,
      this.f_apellido,
      this.f_nombre,
      this.f_direccion,
      this.f_telefono,
      this.f_email,
      this.f_id_usuario,
      this.f_sucursal,
      this.f_cambiar_precio,
      this.f_descuento,
      this.f_mesa,
      this.f_activo,
      this.f_cajero,
      this.f_id_clave,
      this.f_camarero,
      this.f_id_empleado,
      this.f_departamento,
      this.f_vendedor);

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);

  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  @override
  List<Object?> get props => [
        f_codigo_usuario,
        f_apellido,
        f_nombre,
        f_direccion,
        f_telefono,
        f_email,
        f_id_usuario,
        f_sucursal,
        f_cambiar_precio,
        f_descuento,
        f_mesa,
        f_activo,
        f_cajero,
        f_id_clave,
        f_camarero,
        f_id_empleado,
        f_departamento,
        f_vendedor
      ];
}
