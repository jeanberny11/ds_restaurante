// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vendedor.g.dart';

@JsonSerializable()
class Vendedor extends Equatable {
  final int f_idvendedor;
  final String? f_nombre;
  final String? f_apellido;
  final String? f_telefono1;
  final String? f_telefono2;
  final String? f_direccion;
  final bool? f_activo;
  final String? f_nombre2;

  const Vendedor(
      this.f_idvendedor,
      this.f_nombre,
      this.f_apellido,
      this.f_telefono1,
      this.f_telefono2,
      this.f_direccion,
      this.f_activo,
      this.f_nombre2);

  factory Vendedor.fromJson(Map<String, dynamic> json) =>
      _$VendedorFromJson(json);

  Map<String, dynamic> toJson() => _$VendedorToJson(this);

  @override
  List<Object?> get props => [
        f_idvendedor,
        f_nombre,
        f_apellido,
        f_telefono1,
        f_telefono2,
        f_direccion,
        f_activo,
        f_nombre2
      ];
}
