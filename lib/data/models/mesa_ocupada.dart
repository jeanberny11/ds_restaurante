// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mesa_ocupada.g.dart';

@JsonSerializable()
class MesaOcupada extends Equatable {
  final String f_documento;
  final int f_mesa;
  final String f_monto;
  final String? f_nombre_cliente;
  final String? f_direccion;
  final int f_vendedor;
  final String mesa;
  final String camarero;
  final double hora;
  final double minuto;

  const MesaOcupada(
      this.f_documento,
      this.f_mesa,
      this.f_monto,
      this.f_nombre_cliente,
      this.f_direccion,
      this.f_vendedor,
      this.mesa,
      this.camarero,
      this.hora,
      this.minuto);

  factory MesaOcupada.fromJson(Map<String, dynamic> json) =>
      _$MesaOcupadaFromJson(json);

  Map<String, dynamic> toJson() => _$MesaOcupadaToJson(this);

  @override
  List<Object?> get props => [
        f_documento,
        f_mesa,
        f_monto,
        f_nombre_cliente,
        f_direccion,
        f_vendedor,
        mesa,
        camarero,
        hora,
        minuto
      ];
}
