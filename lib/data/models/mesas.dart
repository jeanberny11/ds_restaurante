// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mesas.g.dart';

@JsonSerializable()
class Mesa extends Equatable {
  final int f_id;
  final String? f_descripcion;
  final bool? f_estado;
  final int f_zonaid;

  const Mesa(this.f_id, this.f_descripcion, this.f_estado, this.f_zonaid);

  factory Mesa.fromJson(Map<String, dynamic> json) => _$MesaFromJson(json);

  Map<String, dynamic> toJson() => _$MesaToJson(this);

  @override
  List<Object?> get props => [f_id, f_descripcion, f_estado, f_zonaid];
}
