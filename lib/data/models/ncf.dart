// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ncf.g.dart';

@JsonSerializable()
class Ncf extends Equatable {
  final int f_codigo;
  final String f_descripcion;
  final bool f_visible;

  const Ncf(this.f_codigo, this.f_descripcion, this.f_visible);

  factory Ncf.fromJson(Map<String, dynamic> json) => _$NcfFromJson(json);

  Map<String, dynamic> toJson() => _$NcfToJson(this);

  @override
  List<Object?> get props => [f_codigo, f_descripcion, f_visible];
}
