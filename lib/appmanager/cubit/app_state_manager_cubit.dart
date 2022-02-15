import 'package:bloc/bloc.dart';
import 'package:ds_restaurante/data/hive/boxes_name.dart';
import 'package:ds_restaurante/data/hive/database_setup.dart';
import 'package:ds_restaurante/managers/conexion_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:postgres/postgres.dart';

part 'app_state_manager_state.dart';

class AppStateManagerCubit extends Cubit<AppStateManagerState> {
  AppStateManagerCubit() : super(AppStateManagerInitial());

  Future<void> initApp() async {
    emit(const AppStateManagerloading('Iniciando...'));
    Hive.registerAdapter(DataBaseSetupAdapter());
    await Hive.openBox<DataBaseSetup>(BoxName.databasesetup);
    await Future.delayed(const Duration(seconds: 1));
    emit(AppStateManagerInitialSetup());
  }

  void initSetup() async {
    emit(const AppStateManagerloading('Configurando...'));
    final setupbox = Hive.box<DataBaseSetup>(BoxName.databasesetup);
    final appsetup = setupbox.get('appsetup');
    if (appsetup == null) {
      emit(AppStateManagerUnConfigured());
    } else {
      try {
        ConexionManager().setupConnection(appsetup);
        final con = ConexionManager().connection;
        await con.open();
        await con.close();
        await Future.delayed(const Duration(seconds: 1));
        emit(AppStateManagerInitialized());
      } catch (ex) {
        emit(AppStateManagerError(ex.toString()));
      }
    }
  }

  Future<void> saveSetup(DataBaseSetup setup) async {
    emit(const AppStateManagerloading('Guardando condifuracion...'));
    try {
      final setupbox = Hive.box<DataBaseSetup>(BoxName.databasesetup);
      setupbox.put('appsetup', setup);
      initSetup();
    } on PostgreSQLException catch (pe) {
      emit(AppStateManagerError(pe.message!));
    } on Exception catch (e) {
      emit(AppStateManagerError(e.toString()));
    }
  }
}
