import 'package:hive_flutter/adapters.dart';
part 'database_setup.g.dart';

@HiveType(typeId: 0)
class DataBaseSetup extends HiveObject {
  @HiveField(0)
  late String host;
  @HiveField(1)
  late int port;
  @HiveField(2)
  late String database;
  @HiveField(3)
  late String username;
  @HiveField(4)
  late String password;

  DataBaseSetup() {
    host = '';
    port = 0;
    database = '';
    username = '';
    password = '';
  }
}
