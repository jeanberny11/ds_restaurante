import 'package:ds_restaurante/appmanager/cubit/app_state_manager_cubit.dart';
import 'package:ds_restaurante/data/hive/boxes_name.dart';
import 'package:ds_restaurante/data/hive/database_setup.dart';
import 'package:ds_restaurante/utils/page_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    context.read<AppStateManagerCubit>().initApp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppStateManagerCubit, AppStateManagerState>(
      builder: (context, state) {
        if (state is AppStateManagerloading) {
          return Material(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset('resources/dreamsoftlogo.png'),
                  ),
                  Positioned(
                      bottom: 20.0,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator.adaptive(),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(state.message)
                          ],
                        ),
                      ))
                ],
              ),
            ),
          );
        } else if (state is AppStateManagerError) {
          return Material(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextButton(
                        onPressed: () {
                          context.read<AppStateManagerCubit>().initSetup();
                        },
                        child: const Text('Reintentar')),
                    const SizedBox(
                      height: 15.0,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) => const SetupView(),
                          ))
                              .then((value) {
                            if (value != null) {
                              final setup = value as DataBaseSetup;
                              context
                                  .read<AppStateManagerCubit>()
                                  .saveSetup(setup);
                            }
                          });
                        },
                        child: const Text('Setup'))
                  ],
                ),
              ),
            ),
          );
        } else {
          return Material(
              child: Center(child: Image.asset('resources/dreamsoftlogo.png')));
        }
      },
      listener: (context, state) {
        if (state is AppStateManagerUnConfigured) {
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (context) => const SetupView(),
          ))
              .then((value) {
            if (value != null) {
              final setup = value as DataBaseSetup;
              context.read<AppStateManagerCubit>().saveSetup(setup);
            }
          });
        }
        if (state is AppStateManagerInitialSetup) {
          context.read<AppStateManagerCubit>().initSetup();
        }
        if (state is AppStateManagerInitialized) {
          Navigator.of(context).pushReplacementNamed(PageRoutes.loginroutes);
        }
      },
    );
  }
}

class SetupView extends StatefulWidget {
  const SetupView({Key? key}) : super(key: key);

  @override
  _SetupViewState createState() => _SetupViewState();
}

class _SetupViewState extends State<SetupView> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _databaseController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late FocusNode _hostfocus;
  late FocusNode _portfocus;
  late FocusNode _databasefocus;
  late FocusNode _usernamefocus;
  late FocusNode _passwordfocus;

  @override
  void initState() {
    super.initState();
    _hostController = TextEditingController(text: '');
    _portController = TextEditingController(text: '');
    _databaseController = TextEditingController(text: '');
    _usernameController = TextEditingController(text: '');
    _passwordController = TextEditingController(text: '');
    _hostfocus = FocusNode();
    _portfocus = FocusNode();
    _databasefocus = FocusNode();
    _usernamefocus = FocusNode();
    _passwordfocus = FocusNode();
    _loadSetup();
  }

  @override
  void dispose() {
    _hostfocus.dispose();
    _portfocus.dispose();
    _databasefocus.dispose();
    _usernamefocus.dispose();
    _passwordfocus.dispose();
    super.dispose();
  }

  void _loadSetup() async {
    final setupbox = Hive.box<DataBaseSetup>(BoxName.databasesetup);
    final appsetup = setupbox.get('appsetup');
    if (appsetup != null) {
      setState(() {
        _hostController.text = appsetup.host;
        _portController.text = appsetup.port.toString();
        _databaseController.text = appsetup.database;
        _usernameController.text = appsetup.username;
        _passwordController.text = appsetup.password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formkey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configuracion de conexion'),
          actions: [
            IconButton(
                onPressed: () {
                  if (!_formkey.currentState!.validate()) {
                    return;
                  }
                  _formkey.currentState!.save();
                  final setup = DataBaseSetup()
                    ..host = _hostController.text
                    ..port = int.tryParse(_portController.text) ?? 5432
                    ..database = _databaseController.text
                    ..username = _usernameController.text
                    ..password = _passwordController.text;
                  Navigator.of(context).pop(setup);
                },
                icon: const Icon(Icons.save))
          ],
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: [
              const Text('Host Name'),
              TextFormField(
                controller: _hostController,
                focusNode: _hostfocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  _hostfocus.unfocus();
                  FocusScope.of(context).requestFocus(_portfocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Host Name',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Puerto'),
              TextFormField(
                controller: _portController,
                focusNode: _portfocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  _portfocus.unfocus();
                  FocusScope.of(context).requestFocus(_databasefocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Numero puerto',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Base de datos'),
              TextFormField(
                controller: _databaseController,
                focusNode: _databasefocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  _databasefocus.unfocus();
                  FocusScope.of(context).requestFocus(_usernamefocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre Base de Datos',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Usuario'),
              TextFormField(
                controller: _usernameController,
                focusNode: _usernamefocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) {
                  _usernamefocus.unfocus();
                  FocusScope.of(context).requestFocus(_passwordfocus);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Nombre Usuario',
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Contraseña'),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordfocus,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  _passwordfocus.unfocus();
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Campo obligatorio';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Contraseña',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
