// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categorias.g.dart';

@JsonSerializable()
class Categorias extends Equatable {
  final int f_idcategoria;
  final String f_descripcion;
  final bool f_visible_factura;

  const Categorias(
      this.f_idcategoria, this.f_descripcion, this.f_visible_factura);

  factory Categorias.fromJson(Map<String, dynamic> json) =>
      _$CategoriasFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriasToJson(this);

  @override
  List<Object?> get props => [f_idcategoria, f_descripcion, f_visible_factura];
}
