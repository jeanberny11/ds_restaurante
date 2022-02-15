// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cliente.g.dart';

@JsonSerializable()
class Cliente extends Equatable {
  final int f_id;
  final String? f_nombre;
  final String? f_apellido;
  final String? f_telefono;
  final String f_balance;
  final String f_limite_credito;
  final String? f_email;
  final bool? f_facturarcredito;
  final String f_dias_credito;
  final String? f_celular;
  final String? f_direccion;
  final int f_vendedor;
  final String? f_rif;
  final bool f_exento_impuestos;
  final int? f_precio_venta;
  final bool f_activo;
  final int? f_tipo_comprobante;

  const Cliente(
      this.f_id,
      this.f_nombre,
      this.f_apellido,
      this.f_telefono,
      this.f_balance,
      this.f_limite_credito,
      this.f_email,
      this.f_facturarcredito,
      this.f_dias_credito,
      this.f_celular,
      this.f_direccion,
      this.f_vendedor,
      this.f_rif,
      this.f_exento_impuestos,
      this.f_precio_venta,
      this.f_activo,
      this.f_tipo_comprobante);

  factory Cliente.fromJson(Map<String, dynamic> json) =>
      _$ClienteFromJson(json);

  Map<String, dynamic> toJson() => _$ClienteToJson(this);

  @override
  List<Object?> get props => throw UnimplementedError();
}
