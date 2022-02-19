import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:ds_restaurante/data/hive/boxes_name.dart';
import 'package:ds_restaurante/data/hive/database_setup.dart';
import 'package:ds_restaurante/managers/conexion_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postgres/postgres.dart';
import 'package:path/path.dart' as path;

part 'app_state_manager_state.dart';

class AppStateManagerCubit extends Cubit<AppStateManagerState> {
  AppStateManagerCubit() : super(AppStateManagerInitial()) {
    initApp();
  }

  Future<void> initApp() async {
    emit(const AppStateManagerloading('Iniciando...'));
    Hive.registerAdapter(DataBaseSetupAdapter());
    await Hive.openBox<DataBaseSetup>(BoxName.databasesetup);
    await Future.delayed(const Duration(seconds: 1));
    initSetup();
  }

  void initSetup() async {
    //----Verificando si tiene el archivo serial------//
    emit(const AppStateManagerloading('Cargando Serial...'));
    try {
      final docdirectory = await getApplicationDocumentsDirectory();
      final serialpath = path.join(docdirectory.path, 'serial.json');
      final jsonFile = File(serialpath);
      if (jsonFile.existsSync()) {
        final jsonString = await jsonFile.readAsString();
        final serial = jsonDecode(jsonString);
        if (serial['device_serial'] == "") {
          emit(AppStateManagerSerialNotRegistred());
          return;
        } else {
          emit(const AppStateManagerloading('Verificando Serial...'));
          String deviceid = serial['deviceid'];
          String deviceserial = serial['device_serial'];
          String password = serial['password'];
          var key = utf8.encode(password);
          var bytes = utf8.encode(deviceid);

          var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
          var digest = hmacSha256.convert(bytes);
          final serialstr = digest.toString();
          if (serialstr != deviceserial) {
            emit(AppStateManagerSerialNotRegistred());
            return;
          }
        }
      } else {
        emit(AppStateManagerSerialNotRegistred());
        return;
      }
    } catch (ex) {
      emit(AppStateManagerError(ex.toString()));
      return;
    }
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

  Future<void> verificarSerial(String deviceid, String deviceserial) async {
    emit(const AppStateManagerloading('Verificando serial...'));
    try {
      final docdirectory = await getApplicationDocumentsDirectory();
      final serialpath = path.join(docdirectory.path, 'serial.json');
      final jsonFile = File(serialpath);
      if (jsonFile.existsSync()) {
        final jsonString = await jsonFile.readAsString();
        final serial = jsonDecode(jsonString);
        String password = serial['password'];
        var key = utf8.encode(password);
        var bytes = utf8.encode(deviceid);

        var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
        var digest = hmacSha256.convert(bytes);
        final serialstr = utf8.decode(digest.bytes);
        if (serialstr != deviceserial) {
          emit(const AppStateManagerError('El Serial digitado es invalido'));
          return;
        }
        emit(const AppStateManagerloading('Guardando serial...'));
        serial['deviceid'] = deviceid;
        serial['device_serial'] = serialstr;
        final String filecontent = jsonEncode(serial);
        await jsonFile.writeAsString(filecontent);
        initSetup();
      } else {
        String password = "workhardplayhard";
        var key = utf8.encode(password);
        var bytes = utf8.encode(deviceid);

        var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
        var digest = hmacSha256.convert(bytes);
        final serialstr = digest.toString();
        if (serialstr != deviceserial) {
          emit(const AppStateManagerError('El Serial digitado es invalido'));
          return;
        }
        emit(const AppStateManagerloading('Guardando serial...'));
        final serial = <String, String>{
          "deviceid": deviceid,
          "device_serial": deviceserial,
          "password": password
        };
        final String filecontent = jsonEncode(serial);
        await jsonFile.writeAsString(filecontent);
        initSetup();
      }
    } catch (ex) {
      emit(AppStateManagerError(ex.toString()));
      return;
    }
  }
}
