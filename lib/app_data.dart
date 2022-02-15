import 'package:ds_restaurante/data/models/usuario.dart';
import 'package:ds_restaurante/data/models/vendedor.dart';

class AppData {
  static final AppData _singleton = AppData._internal();
  factory AppData() {
    return _singleton;
  }
  AppData._internal();

  Usuario? currentUsuario;
  Vendedor? currentVendedor;
}
