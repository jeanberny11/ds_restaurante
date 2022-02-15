import 'package:ds_restaurante/data/models/cliente.dart';
import 'package:ds_restaurante/managers/conexion_manager.dart';

class ClientesManager {
  Future<List<Cliente>> getAllClientes() async {
    List<Cliente> clientes = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    const sql =
        'select f_id,f_nombre,f_apellido,f_telefono,f_balance,f_fecha,f_limite_credito,f_email,f_facturarcredito,f_dias_credito,'
        'f_celular,f_direccion,f_vendedor,f_rif,f_exento_impuestos,f_precio_venta,f_activo,f_tipo_comprobante from t_clientes where f_activo=true order by f_id';
    final res = await conexion.mappedResultsQuery(sql);
    final rescli =
        res.map<Map<String, dynamic>>((e) => e['t_clientes']!).toList();
    clientes.addAll(rescli.map<Cliente>((e) => Cliente.fromJson(e)));
    await conexion.close();
    return clientes;
  }

  Future<List<Cliente>> searchClientes(String query) async {
    List<Cliente> clientes = [];
    final conexion = ConexionManager().connection;
    await conexion.open();
    String sql = '';
    if (query == '*') {
      sql =
          'select f_id,f_nombre,f_apellido,f_telefono,f_balance,f_fecha,f_limite_credito,f_email,f_facturarcredito,f_dias_credito,'
          'f_celular,f_direccion,f_vendedor,f_rif,f_exento_impuestos,f_precio_venta,f_activo,f_tipo_comprobante from t_clientes where f_activo=true order by f_id';
    } else {
      sql =
          "select f_id,f_nombre,f_apellido,f_telefono,f_balance,f_fecha,f_limite_credito,f_email,f_facturarcredito,f_dias_credito,"
          "f_celular,f_direccion,f_vendedor,f_rif,f_exento_impuestos,f_precio_venta,f_activo,f_tipo_comprobante from t_clientes where f_activo=true "
          " and cast(f_id as varchar)='$query' or f_nombre ilike '%$query%' or f_rif ilike '$query%' order by f_id";
    }
    final res = await conexion.mappedResultsQuery(sql);
    final rescli =
        res.map<Map<String, dynamic>>((e) => e['t_clientes']!).toList();
    clientes.addAll(rescli.map<Cliente>((e) => Cliente.fromJson(e)));
    await conexion.close();
    return clientes;
  }
}
