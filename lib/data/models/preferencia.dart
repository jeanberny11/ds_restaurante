// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferencia.g.dart';

@JsonSerializable()
class Preferencia extends Equatable {
  final String f_ley;
  final bool f_itbis_incluido;

  const Preferencia(this.f_ley, this.f_itbis_incluido);

  factory Preferencia.fromJson(Map<String, dynamic> json) =>
      _$PreferenciaFromJson(json);

  Map<String, dynamic> toJson() => _$PreferenciaToJson(this);

  @override
  List<Object?> get props => [f_ley];
}
