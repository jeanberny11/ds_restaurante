import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comanda_item.g.dart';

@JsonSerializable()
class ComandaItem extends Equatable {
  final String referencia;
  final String descripcion;
  final double cantidad;
  final double precio;
  final double costo;
  final int idcategoria;
  final double pimpuesto;
  final double montobruto;
  final bool tieneimpuesto;
  final double montoexento;
  final double baseimponible;
  final double impuesto;
  final double pley;
  final double ley;
  final double total;
  final String nota;
  final int orden;
  final bool despachado;
  final double cantidad2;

  const ComandaItem(
      this.referencia,
      this.descripcion,
      this.cantidad,
      this.precio,
      this.costo,
      this.idcategoria,
      this.pimpuesto,
      this.montobruto,
      this.tieneimpuesto,
      this.montoexento,
      this.baseimponible,
      this.impuesto,
      this.pley,
      this.ley,
      this.total,
      this.nota,
      this.orden,
      this.despachado,
      this.cantidad2);

  factory ComandaItem.fromJson(Map<String, dynamic> json) =>
      _$ComandaItemFromJson(json);

  Map<String, dynamic> toJson() => _$ComandaItemToJson(this);

  @override
  List<Object?> get props => [
        referencia,
        descripcion,
        cantidad,
        precio,
        costo,
        idcategoria,
        pimpuesto,
        montobruto,
        tieneimpuesto,
        montoexento,
        baseimponible,
        impuesto,
        pley,
        ley,
        total,
        orden,
        despachado,
        cantidad2
      ];

  ComandaItem copyWith(
      {String? referencia,
      String? descripcion,
      double? cantidad,
      double? precio,
      double? costo,
      int? idcategoria,
      double? pimpuesto,
      double? montobruto,
      bool? tieneimpuesto,
      double? montoexento,
      double? baseimponible,
      double? impuesto,
      double? pley,
      double? ley,
      double? total,
      String? nota,
      int? orden,
      bool? despachado,
      double? cantidad2}) {
    return ComandaItem(
        referencia ?? this.referencia,
        descripcion ?? this.descripcion,
        cantidad ?? this.cantidad,
        precio ?? this.precio,
        costo ?? this.costo,
        idcategoria ?? this.idcategoria,
        pimpuesto ?? this.pimpuesto,
        montobruto ?? this.montobruto,
        tieneimpuesto ?? this.tieneimpuesto,
        montoexento ?? this.montoexento,
        baseimponible ?? this.baseimponible,
        impuesto ?? this.impuesto,
        pley ?? this.pley,
        ley ?? this.ley,
        total ?? this.total,
        nota ?? this.nota,
        orden ?? this.orden,
        despachado ?? this.despachado,
        cantidad2 ?? this.cantidad2);
  }
}
