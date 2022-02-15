// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'zonas_mesas.g.dart';

@JsonSerializable()
class Zona extends Equatable {
  final int f_id;
  final String? f_descripcion;
  final bool? f_activo;

  const Zona(this.f_id, this.f_descripcion, this.f_activo);

  factory Zona.fromJson(Map<String, dynamic> json) => _$ZonaFromJson(json);

  Map<String, dynamic> toJson() => _$ZonaToJson(this);

  @override
  List<Object?> get props => [f_id, f_descripcion, f_activo];
}
