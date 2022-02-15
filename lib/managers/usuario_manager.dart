import 'package:ds_restaurante/data/models/usuario.dart';
import 'package:ds_restaurante/data/models/vendedor.dart';
import 'package:ds_restaurante/managers/conexion_manager.dart';

class UsuarioManager {
  Future<Usuario?> authUsuario(int clave) async {
    Usuario? usuario;
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion
        .mappedResultsQuery('select * from t_usuario where f_id_clave=$clave');
    if (res.isNotEmpty) {
      final userresult = res[0]['t_usuario'];
      usuario = Usuario.fromJson(userresult!);
    }
    await conexion.close();
    return usuario;
  }

  Future<Vendedor?> getVendedorById(int vendedirid) async {
    Vendedor? vendedor;
    final conexion = ConexionManager().connection;
    await conexion.open();
    final res = await conexion.mappedResultsQuery(
        'select * from t_vendedores where f_idvendedor=$vendedirid');
    if (res.isNotEmpty) {
      final vresult = res[0]['t_vendedores'];
      vendedor = Vendedor.fromJson(vresult!);
    }
    await conexion.close();
    return vendedor;
  }
}
