import 'package:ds_restaurante/data/hive/database_setup.dart';
import 'package:postgres/postgres.dart';

class ConexionManager {
  static final ConexionManager _singleton = ConexionManager._internal();

  DataBaseSetup? _setup;

  factory ConexionManager() {
    return _singleton;
  }
  ConexionManager._internal();

  void setupConnection(DataBaseSetup setup) {
    _setup = setup;
  }

  PostgreSQLConnection get connection {
    if (_setup == null) {
      throw Exception('No se ha configurado la conexion');
    }
    return PostgreSQLConnection(_setup!.host, _setup!.port, _setup!.database,
        username: _setup!.username, password: _setup!.password);
  }
}
