// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detalle_comanda.g.dart';

@JsonSerializable()
class DetalleComanda extends Equatable {
  final String documento;
  final int nodoc;
  final String tipodoc;
  final String referencia;
  final double precio;
  final double cantidad;
  final DateTime fecha;
  final double total;
  final String producto;
  final int orden;
  final bool impreso;
  final double itbis;
  final double ley;
  final int silla;
  final String nota;
  final int division;
  final bool facturado;
  final double cantidad2;
  final int conteo;
  final String comentario;
  final bool despachado;

  const DetalleComanda(
      this.documento,
      this.nodoc,
      this.tipodoc,
      this.referencia,
      this.precio,
      this.cantidad,
      this.fecha,
      this.total,
      this.producto,
      this.orden,
      this.impreso,
      this.itbis,
      this.ley,
      this.silla,
      this.nota,
      this.division,
      this.facturado,
      this.cantidad2,
      this.conteo,
      this.comentario,
      this.despachado);

  factory DetalleComanda.fromJson(Map<String, dynamic> json) =>
      _$DetalleComandaFromJson(json);

  Map<String, dynamic> toJson() => _$DetalleComandaToJson(this);

  @override
  List<Object?> get props => [
        documento,
        nodoc,
        tipodoc,
        referencia,
        precio,
        cantidad,
        fecha,
        total,
        producto,
        orden,
        impreso,
        itbis,
        ley,
        silla,
        nota,
        division,
        facturado,
        cantidad2,
        conteo,
        comentario,
        despachado
      ];

  DetalleComanda copyWith({
    String? documento,
    int? nodoc,
    String? tipodoc,
    String? referencia,
    double? precio,
    double? cantidad,
    DateTime? fecha,
    double? total,
    String? producto,
    int? orden,
    bool? impreso,
    double? itbis,
    double? ley,
    int? silla,
    String? nota,
    int? division,
    bool? facturado,
    double? cantidad2,
    int? conteo,
    String? comentario,
    bool? despachado,
  }) {
    return DetalleComanda(
      documento ?? this.documento,
      nodoc ?? this.nodoc,
      tipodoc ?? this.tipodoc,
      referencia ?? this.referencia,
      precio ?? this.precio,
      cantidad ?? this.cantidad,
      fecha ?? this.fecha,
      total ?? this.total,
      producto ?? this.producto,
      orden ?? this.orden,
      impreso ?? this.impreso,
      itbis ?? this.itbis,
      ley ?? this.ley,
      silla ?? this.silla,
      nota ?? this.nota,
      division ?? this.division,
      facturado ?? this.facturado,
      cantidad2 ?? this.cantidad2,
      conteo ?? this.conteo,
      comentario ?? this.comentario,
      despachado ?? this.despachado,
    );
  }
}
