import 'package:ds_restaurante/data/models/categorias.dart';
import 'package:ds_restaurante/data/models/detalle_comanda.dart';
import 'package:ds_restaurante/data/models/header_comanda.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/data/models/mesas.dart';
import 'package:ds_restaurante/data/models/ncf.dart';
import 'package:ds_restaurante/data/models/preferencia.dart';
import 'package:ds_restaurante/data/models/productos.dart';
import 'package:ds_restaurante/data/models/zonas_mesas.dart';
import 'package:ds_restaurante/managers/conexion_manager.dart';
import 'package:ds_restaurante/utils/app_utils.dart';

class ComandasManager {
  Future<List<Zona>> getAllZonas() async {
    List<Zona> zonas = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion
        .mappedResultsQuery('select * from t_zonas_mesas where f_activo=true');
    final reszonas =
        res.map<Map<String, dynamic>>((e) => e['t_zonas_mesas']!).toList();
    zonas.addAll(reszonas.map<Zona>((e) => Zona.fromJson(e)));
    await conexion.close();
    return zonas;
  }

  Future<List<Mesa>> getMesasZona(int zonaid) async {
    List<Mesa> mesas = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        'select * from t_mesa where f_zonaid=$zonaid order by f_id');
    if (res.isNotEmpty) {
      final resmesas =
          res.map<Map<String, dynamic>>((e) => e['t_mesa']!).toList();
      mesas.addAll(resmesas.map<Mesa>((e) => Mesa.fromJson(e)));
    }
    await conexion.close();
    return mesas;
  }

  Future<List<MesaOcupada>> getMesasOcupadas() async {
    List<MesaOcupada> mesas = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    const sql =
        'select f_documento,f_mesa,f_monto,f_direccion,f_nombre_cliente,f_vendedor,get_mesa(f_mesa) as mesa,'
        'get_nombre_vendedor(f_vendedor)as camarero,EXTRACT(hour from CURRENT_TIME-f_hora)as hora,'
        'EXTRACT(minute from CURRENT_TIME-f_hora)as minuto from t_factura_temp where f_cerrado=false';
    final res = await conexion.mappedResultsQuery(sql);
    if (res.isNotEmpty) {
      for (final row in res) {
        Map<String, dynamic> rowdata = {};
        for (final k in row.keys) {
          rowdata.addAll(row[k]!);
        }
        mesas.add(MesaOcupada.fromJson(rowdata));
      }
      /*final resmesas =
          res.map<Map<String, dynamic>>((e) => e['t_factura_temp']!).toList();
      mesas.addAll(resmesas.map<MesaOcupada>((e) => MesaOcupada.fromJson(e)));*/
    }
    await conexion.close();
    return mesas;
  }

  Future<List<Categorias>> getAllCategorias() async {
    List<Categorias> categorias = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        'select * from t_categorias where f_visible_factura=true order by f_idcategoria');
    if (res.isNotEmpty) {
      final rescategoria =
          res.map<Map<String, dynamic>>((e) => e['t_categorias']!).toList();
      categorias
          .addAll(rescategoria.map<Categorias>((e) => Categorias.fromJson(e)));
    }
    await conexion.close();
    return categorias;
  }

  Future<List<Productos>> getProductosCategoria(int categoriaid) async {
    List<Productos> productos = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        'select * from t_productos_sucursal where f_disponible_facturacion=true and f_idcategoria=$categoriaid order by f_referencia');
    if (res.isNotEmpty) {
      final resprod = res
          .map<Map<String, dynamic>>((e) => e['t_productos_sucursal']!)
          .toList();
      productos.addAll(resprod.map<Productos>((e) => Productos.fromJson(e)));
    }
    await conexion.close();
    return productos;
  }

  Future<Productos?> getProducto(String referencia) async {
    Productos? producto;
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        "select * from t_productos_sucursal where f_referencia='$referencia'");
    if (res.isNotEmpty) {
      producto = Productos.fromJson(res[0]["t_productos_sucursal"]!);
    }
    await conexion.close();
    return producto;
  }

  Future<List<Ncf>> getNcfs() async {
    List<Ncf> ncfs = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        'select * from t_ncf where f_visible order by f_codigo');
    if (res.isNotEmpty) {
      final resncf = res.map<Map<String, dynamic>>((e) => e['t_ncf']!).toList();
      ncfs.addAll(resncf.map<Ncf>((e) => Ncf.fromJson(e)));
    }
    await conexion.close();
    return ncfs;
  }

  Future<Preferencia?> getPreferencia() async {
    Preferencia? preferencia;
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res =
        await conexion.mappedResultsQuery('select * from t_preferencia');
    if (res.isNotEmpty) {
      final prefresult = res[0]['t_preferencia'];
      preferencia = Preferencia.fromJson(prefresult!);
    }
    await conexion.close();
    return preferencia;
  }

  Future<HeaderComanda?> getComanda(String documento) async {
    HeaderComanda? header;
    final conexion = ConexionManager().connection;
    await conexion.open();
    final sql =
        "SELECT f_documento,f_nodoc,f_tipodoc,f_monto,f_itbis,f_fecha,f_hechopor,f_mesa,"
        "f_vendedor,f_cerrado,f_modificada_por,f_descuento,f_cliente,f_nombre_cliente,f_direccion,"
        "f_telefono,f_ley,f_linea,f_factura,f_personas,f_nota,f_instalador,f_delivery,f_separado,f_rnc"
        " FROM t_factura_temp where f_documento='$documento'";
    final res = await conexion.query(sql);
    if (res.isNotEmpty) {
      final row = res.first;
      header = HeaderComanda(
          row[0],
          row[1],
          row[2],
          double.tryParse(row[3]) ?? 0,
          double.tryParse(row[4]) ?? 0,
          row[5],
          row[6],
          row[7],
          row[8],
          row[9],
          row[10] ?? 0,
          double.tryParse(row[11]) ?? 0,
          row[12],
          row[13] ?? '',
          row[14] ?? '',
          row[15] ?? '',
          double.tryParse(row[16]) ?? 0,
          row[18] ?? '',
          row[20] ?? '',
          double.tryParse(row[22]) ?? 0,
          row[23],
          row[24] ?? '');
    }
    await conexion.close();
    return header;
  }

  Future<List<DetalleComanda>> getDetalleComanda(String documento) async {
    final List<DetalleComanda> detalles = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    String sql =
        "SELECT f_documento,f_nodoc,f_tipodoc,f_referencia,f_precio,f_cantidad,f_fecha,f_total,f_producto,"
        "f_orden,f_impreso,f_itbis,f_ley,f_silla,f_nota,f_division,f_facturado,f_cantidad2,f_conteo,"
        "f_comentario,f_proyecto,f_fideicomiso,f_despachado FROM t_detalle_factura_temp  where f_documento='$documento' order by f_orden";
    final res = await conexion.query(sql);
    for (final row in res) {
      final detalle = DetalleComanda(
          row[0],
          row[1],
          row[2],
          row[3],
          double.tryParse(row[4]) ?? 0,
          double.tryParse(row[5]) ?? 0,
          row[6],
          double.tryParse(row[7]) ?? 0,
          row[8],
          row[9],
          row[10],
          double.tryParse(row[11]) ?? 0,
          double.tryParse(row[12]) ?? 0,
          0,
          row[14],
          row[15],
          row[16],
          double.tryParse(row[17]) ?? 0,
          0,
          row[19] ?? '',
          row[22] ?? false);
      detalles.add(detalle);
    }
    await conexion.close();
    return detalles;
  }

  Future<List<DetalleComanda>> getDetalleComandaSeparar(
      String documento) async {
    final List<DetalleComanda> detalles = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    String sql =
        "SELECT f_documento,f_nodoc,f_tipodoc,f_referencia,f_precio,f_cantidad,f_fecha,f_total,f_producto,"
        "f_orden,f_impreso,f_itbis,f_ley,f_silla,f_nota,f_division,f_facturado,f_cantidad2,f_conteo,"
        "f_comentario,f_proyecto,f_fideicomiso,f_despachado FROM t_detalle_factura_temp  where (f_cantidad-f_cantidad2)>0 and f_documento='$documento' order by f_orden";
    final res = await conexion.query(sql);
    for (final row in res) {
      final detalle = DetalleComanda(
          row[0],
          row[1],
          row[2],
          row[3],
          double.tryParse(row[4]) ?? 0,
          double.tryParse(row[5]) ?? 0,
          row[6],
          double.tryParse(row[7]) ?? 0,
          row[8],
          row[9],
          row[10],
          double.tryParse(row[11]) ?? 0,
          double.tryParse(row[12]) ?? 0,
          0,
          row[14],
          row[15],
          row[16],
          double.tryParse(row[17]) ?? 0,
          0,
          row[19] ?? '',
          row[22] ?? false);
      detalles.add(detalle);
    }
    await conexion.close();
    return detalles;
  }

  Future<void> salvarComanda(bool nuevo, HeaderComanda headerComanda,
      List<DetalleComanda> detalle, List<MesaOcupada> mesajuntas) async {
    final conexion = ConexionManager().connection;
    await conexion.open();
    await conexion.transaction((connection) async {
      String documento = headerComanda.documento;
      String tipodoc = headerComanda.tipodoc;
      int secuencia = 0;
      if (nuevo) {
        final ressec = await connection
            .query("select get_secuencia('$tipodoc') as secuencia");
        secuencia = ressec[0][0];
        final resdoc = await connection
            .query("select towholenum('$tipodoc',$secuencia) as documento");
        documento = resdoc[0][0];
      } else {
        final resdoc = await connection.query(
            "select f_documento,f_nodoc,f_tipodoc from t_factura_temp where f_documento='$documento'");
        documento = resdoc[0][0];
        secuencia = resdoc[0][1];
        tipodoc = resdoc[0][2];
      }
      await connection
          .execute("delete from t_factura_temp where f_documento='$documento'");
      await connection.execute(
          "delete from t_detalle_factura_temp where f_documento='$documento'");

      await connection.query(
          "insert into t_factura_temp (f_documento,f_nodoc,f_tipodoc,f_monto,f_itbis,f_fecha,f_hechopor,f_mesa,f_vendedor,"
          "f_cerrado,f_cliente,f_nombre_cliente,f_ley,f_linea,f_delivery,f_separado,f_rnc) values"
          "(@documento,@nodoc,@tipodoc,@monto,@itbis,@fecha,@hechopor,@mesa,@vendedor,@cerrado,@cliente,@nombrecliente,@ley,@linea,@delivery,@separado,@rnc)",
          substitutionValues: {
            "documento": documento,
            "nodoc": secuencia,
            "tipodoc": tipodoc,
            "monto": headerComanda.monto,
            "itbis": headerComanda.itbis,
            "fecha": dtos(headerComanda.fecha),
            "hechopor": headerComanda.usuarioid,
            "mesa": headerComanda.mesa,
            "vendedor": headerComanda.vendedor,
            "cerrado": false,
            "cliente": headerComanda.clienteid,
            "nombrecliente": headerComanda.nombrecliente,
            "ley": headerComanda.ley,
            "linea": 0,
            "delivery": headerComanda.delivery,
            "separado": false,
            "rnc": headerComanda.rnc
          });
      for (final det in detalle) {
        await connection.query(
            "insert into t_detalle_factura_temp (f_documento,f_nodoc,f_tipodoc,f_referencia,f_precio,f_cantidad,f_fecha,"
            "f_total,f_producto,f_orden,f_impreso,f_itbis,f_ley,f_nota,f_division,f_conteo,f_comentario,f_despachado) values "
            " (@documento,@nodoc,@tipodoc,@referencia,@precio,@cantidad,@fecha,@total,@producto,@orden,@impreso,@itbis,@ley,@nota,@division,@conteo,@comentario,@despachado)",
            substitutionValues: {
              "documento": documento,
              "nodoc": secuencia,
              "tipodoc": tipodoc,
              "referencia": det.referencia,
              "precio": det.precio,
              "cantidad": det.cantidad,
              "fecha": dtos(det.fecha),
              "total": det.total,
              "producto": det.producto,
              "orden": det.orden,
              "impreso": det.impreso,
              "itbis": det.itbis,
              "ley": det.ley,
              "nota": det.nota,
              "division": det.division,
              "conteo": 0,
              "comentario": "",
              "despachado": det.despachado
            });
      }
      for (final mesa in mesajuntas) {
        await connection.execute(
            "update t_factura_temp set f_cerrado=true where f_documento='${mesa.f_documento}'");
      }
    });
    await conexion.close();
  }

  Future<void> salvarComandaSeparada(String documento,
      HeaderComanda headerComanda, List<DetalleComanda> detalle) async {
    final conexion = ConexionManager().connection;
    await conexion.open();
    await conexion.transaction((connection) async {
      final comanda = await connection.query(
          "select f_documento,f_tipodoc,f_nodoc,f_fecha as fecha,current_time as hora from t_factura_temp where f_documento='$documento'");
      final String doccomanda = comanda[0][0];
      final String tipodoccomanda = comanda[0][1];
      final ressec = await connection
          .query("select get_secuencia('$doccomanda') as secuencia");
      int secuencia = ressec[0][0];
      final String docprecuenta = "$documento-$secuencia";

      await connection.query(
          "insert into t_factura_temp_2 (f_documento,f_nodoc,f_tipodoc,f_monto,f_itbis,f_fecha,f_hechopor,f_mesa,f_vendedor,"
          "f_cerrado,f_cliente,f_nombre_cliente,f_ley,f_linea,f_delivery,f_rnc,f_documento2) values"
          "(@documento,@nodoc,@tipodoc,@monto,@itbis,@fecha,@hechopor,@mesa,@vendedor,@cerrado,@cliente,@nombrecliente,@ley,@linea,@delivery,@rnc,@documento2)",
          substitutionValues: {
            "documento": docprecuenta,
            "nodoc": secuencia,
            "tipodoc": tipodoccomanda,
            "monto": headerComanda.monto,
            "itbis": headerComanda.itbis,
            "fecha": dtos(headerComanda.fecha),
            "hechopor": headerComanda.usuarioid,
            "mesa": headerComanda.mesa,
            "vendedor": headerComanda.vendedor,
            "cerrado": false,
            "cliente": headerComanda.clienteid,
            "nombrecliente": headerComanda.nombrecliente,
            "ley": headerComanda.ley,
            "linea": 0,
            "delivery": headerComanda.delivery,
            "rnc": headerComanda.rnc,
            "documento2": documento
          });
      await connection.execute(
          "update t_factura_temp set f_separado=true where f_documento='$documento'");
      for (final det in detalle) {
        await connection.query(
            "insert into t_detalle_factura_temp (f_documento,f_nodoc,f_tipodoc,f_referencia,f_precio,f_cantidad,f_fecha,"
            "f_total,f_producto,f_orden,f_impreso,f_itbis,f_ley,f_nota,f_division,f_cantidad2,f_conteo,f_comentario,f_despachado) values "
            " (@documento,@nodoc,@tipodoc,@referencia,@precio,@cantidad,@fecha,@total,@producto,@orden,@impreso,@itbis,@ley,@nota,@division,@cantidad2,@conteo,@comentario,@despachado)",
            substitutionValues: {
              "documento": docprecuenta,
              "nodoc": secuencia,
              "tipodoc": tipodoccomanda,
              "referencia": det.referencia,
              "precio": det.precio,
              "cantidad": det.cantidad,
              "fecha": dtos(det.fecha),
              "total": det.total,
              "producto": det.producto,
              "orden": det.orden,
              "impreso": det.impreso,
              "itbis": det.itbis,
              "ley": det.ley,
              "nota": det.nota,
              "division": det.division,
              "cantidad2": 0,
              "conteo": 0,
              "comentario": "",
              "despachado": det.despachado
            });
        await connection.execute(
            "update t_detalle_factura_temp set f_cantidad2=f_cantidad2+${det.cantidad} where f_documento='$documento' and f_referencia='${det.referencia}'");
      }
    });
    await conexion.close();
  }

  Future<List<SelectedListItem<MesaOcupada>>> getMesasJunar(
      int mesaactual) async {
    final List<MesaOcupada> mesas = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    final sql =
        'select f_documento,f_mesa,f_monto,f_direccion,f_nombre_cliente,f_vendedor,get_mesa(f_mesa) as mesa,'
        'get_nombre_vendedor(f_vendedor)as camarero,EXTRACT(hour from CURRENT_TIME-f_hora)as hora,'
        'EXTRACT(minute from CURRENT_TIME-f_hora)as minuto from t_factura_temp where f_cerrado=false and f_mesa<>$mesaactual';
    final res = await conexion.query(sql);
    if (res.isNotEmpty) {
      for (final row in res) {
        final mesa = MesaOcupada(row[0], row[1], row[2], row[4] ?? '',
            row[3] ?? '', row[5], row[6] ?? '', row[7] ?? '', row[8], row[9]);
        mesas.add(mesa);
      }
    }
    await conexion.close();
    return mesas
        .map<SelectedListItem<MesaOcupada>>(
            (e) => SelectedListItem<MesaOcupada>(e))
        .toList();
  }
}
