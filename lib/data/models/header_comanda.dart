import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'header_comanda.g.dart';

@JsonSerializable()
class HeaderComanda extends Equatable {
  final String documento;
  final int nodoc;
  final String tipodoc;
  final double monto;
  final double itbis;
  final DateTime fecha;
  final int usuarioid;
  final int mesa;
  final int vendedor;
  final bool cerrado;
  final int usuariomodi;
  final double descuento;
  final int clienteid;
  final String nombrecliente;
  final String direccion;
  final String telefono;
  final double ley;
  final String factura;
  final String nota;
  final double delivery;
  final bool separado;
  final String rnc;

  const HeaderComanda(
      this.documento,
      this.nodoc,
      this.tipodoc,
      this.monto,
      this.itbis,
      this.fecha,
      this.usuarioid,
      this.mesa,
      this.vendedor,
      this.cerrado,
      this.usuariomodi,
      this.descuento,
      this.clienteid,
      this.nombrecliente,
      this.direccion,
      this.telefono,
      this.ley,
      this.factura,
      this.nota,
      this.delivery,
      this.separado,
      this.rnc);

  factory HeaderComanda.fromJson(Map<String, dynamic> json) =>
      _$HeaderComandaFromJson(json);

  Map<String, dynamic> toJson() => _$HeaderComandaToJson(this);

  @override
  List<Object?> get props => [
        documento,
        nodoc,
        tipodoc,
        monto,
        itbis,
        fecha,
        usuarioid,
        mesa,
        vendedor,
        cerrado,
        usuariomodi,
        descuento,
        clienteid,
        nombrecliente,
        direccion,
        telefono,
        ley,
        factura,
        nota,
        delivery,
        separado,
        rnc
      ];

  HeaderComanda copyWith({
    String? documento,
    int? nodoc,
    String? tipodoc,
    double? monto,
    double? itbis,
    DateTime? fecha,
    String? hora,
    int? usuarioid,
    int? mesa,
    int? vendedor,
    bool? cerrado,
    int? usuariomodi,
    double? descuento,
    int? clienteid,
    String? nombrecliente,
    String? direccion,
    String? telefono,
    double? ley,
    String? factura,
    String? nota,
    double? delivery,
    bool? separado,
    String? rnc,
  }) {
    return HeaderComanda(
      documento ?? this.documento,
      nodoc ?? this.nodoc,
      tipodoc ?? this.tipodoc,
      monto ?? this.monto,
      itbis ?? this.itbis,
      fecha ?? this.fecha,
      usuarioid ?? this.usuarioid,
      mesa ?? this.mesa,
      vendedor ?? this.vendedor,
      cerrado ?? this.cerrado,
      usuariomodi ?? this.usuariomodi,
      descuento ?? this.descuento,
      clienteid ?? this.clienteid,
      nombrecliente ?? this.nombrecliente,
      direccion ?? this.direccion,
      telefono ?? this.telefono,
      ley ?? this.ley,
      factura ?? this.factura,
      nota ?? this.nota,
      delivery ?? this.delivery,
      separado ?? this.separado,
      rnc ?? this.rnc,
    );
  }
}
