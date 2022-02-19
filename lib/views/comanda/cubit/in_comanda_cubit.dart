import 'package:bloc/bloc.dart';
import 'package:ds_restaurante/data/models/categorias.dart';
import 'package:ds_restaurante/data/models/cliente.dart';
import 'package:ds_restaurante/data/models/detalle_comanda.dart';
import 'package:ds_restaurante/data/models/header_comanda.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/data/models/ncf.dart';
import 'package:ds_restaurante/data/models/preferencia.dart';
import 'package:ds_restaurante/data/models/productos.dart';
import 'package:ds_restaurante/managers/clientes_manager.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:equatable/equatable.dart';

part 'in_comanda_state.dart';

class InComandaCubit extends Cubit<InComandaState> {
  final ComandasManager _manager;
  final ClientesManager _clientesManager;
  InComandaCubit(this._manager, this._clientesManager)
      : super(InComandaInitial());

  Future<List<Categorias>> get getAllCategorias => _manager.getAllCategorias();

  Future<List<Productos>> getProductosCategoria(int categoriaid) =>
      _manager.getProductosCategoria(categoriaid);

  Future<List<Ncf>> get getAllNcfs => _manager.getNcfs();

  Future<Preferencia?> get getPreferencia => _manager.getPreferencia();

  Future<Productos?> getProducto(String referencia) =>
      _manager.getProducto(referencia);

  Future<List<Cliente>> searchClientes(String query) =>
      _clientesManager.searchClientes(query);

  Future<List<Cliente>> get getAllClientes => _clientesManager.getAllClientes();

  Future<void> salvarComanda(bool nuevo, HeaderComanda headerComanda,
          List<DetalleComanda> detalle, List<MesaOcupada> mesasjuntas) =>
      _manager.salvarComanda(nuevo, headerComanda, detalle, mesasjuntas);

  Future<HeaderComanda?> getComanda(String documento) =>
      _manager.getComanda(documento);

  Future<List<DetalleComanda>> getDetalleComanda(String documento) =>
      _manager.getDetalleComanda(documento);

  Future<Cliente?> getClienteById(int clienteid) =>
      _clientesManager.getClienteById(clienteid);
}
