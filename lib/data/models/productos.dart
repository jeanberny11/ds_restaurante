// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'productos.g.dart';

@JsonSerializable()
class Productos extends Equatable {
  final String f_referencia;
  final String f_descripcion;
  final bool f_controlinventario;
  final int f_idcategoria;
  final String f_maxdescuento;
  final String f_precio;
  final String f_precio2;
  final String f_precio3;
  final String f_precio4;
  final String f_precio5;
  final String f_precio6;
  final String f_ultimocosto;
  final bool f_tieneitbs;
  final String? f_referencia_suplidor;
  final int f_iddepto;
  final String? f_id_barra;
  final int f_idmarca;
  final bool f_oferta;
  final String f_impuesto;

  const Productos(
      this.f_referencia,
      this.f_descripcion,
      this.f_controlinventario,
      this.f_idcategoria,
      this.f_maxdescuento,
      this.f_precio,
      this.f_precio2,
      this.f_precio3,
      this.f_precio4,
      this.f_precio5,
      this.f_precio6,
      this.f_ultimocosto,
      this.f_tieneitbs,
      this.f_referencia_suplidor,
      this.f_iddepto,
      this.f_id_barra,
      this.f_idmarca,
      this.f_oferta,
      this.f_impuesto);

  factory Productos.fromJson(Map<String, dynamic> json) =>
      _$ProductosFromJson(json);

  Map<String, dynamic> toJson() => _$ProductosToJson(this);

  @override
  List<Object?> get props => [
        f_referencia,
        f_descripcion,
        f_controlinventario,
        f_idcategoria,
        f_maxdescuento,
        f_precio,
        f_precio2,
        f_precio3,
        f_precio4,
        f_precio5,
        f_precio6,
        f_ultimocosto,
        f_referencia_suplidor,
        f_iddepto,
        f_id_barra,
        f_idmarca,
        f_oferta,
        f_impuesto
      ];
}
