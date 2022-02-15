import 'package:ds_restaurante/appmanager/cubit/app_state_manager_cubit.dart';
import 'package:ds_restaurante/appmanager/splash_screen.dart';
import 'package:ds_restaurante/managers/clientes_manager.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:ds_restaurante/managers/usuario_manager.dart';
import 'package:ds_restaurante/utils/page_routes.dart';
import 'package:ds_restaurante/views/comanda/cubit/in_comanda_cubit.dart';
import 'package:ds_restaurante/views/comanda/cubit/out_zonas_cubit.dart';
import 'package:ds_restaurante/views/comanda/in_comanda.dart';
import 'package:ds_restaurante/views/comanda/out_comanda.dart';
import 'package:ds_restaurante/views/login/cubit/login_cubit.dart';
import 'package:ds_restaurante/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  //Hive.registerAdapter(adapter)
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) =>
          BlocProvider<AppStateManagerCubit>(
        create: (context) => AppStateManagerCubit(),
        child: MultiProvider(
          providers: [
            Provider<UsuarioManager>(
              create: (context) => UsuarioManager(),
            ),
            Provider<ComandasManager>(
              create: (context) => ComandasManager(),
            ),
            Provider<ClientesManager>(
              create: (context) => ClientesManager(),
            )
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'App Restaurante',
            theme: ThemeData(
              brightness: Brightness.light,
              primaryColorDark: const Color(0xFF0100ca),
              primaryColor: const Color(0xFF651fff),
              textTheme:
                  GoogleFonts.oswaldTextTheme(Theme.of(context).textTheme),
            ),
            initialRoute: PageRoutes.splashcreenroute,
            onGenerateRoute: (setting) {
              switch (setting.name) {
                case PageRoutes.splashcreenroute:
                  {
                    return MaterialPageRoute(
                      builder: (context) => const SplashScreen(),
                    );
                  }
                case PageRoutes.loginroutes:
                  {
                    return MaterialPageRoute(
                      builder: (context) => BlocProvider<LoginCubit>(
                          create: (context) =>
                              LoginCubit(context.read<UsuarioManager>()),
                          child: const Login()),
                    );
                  }
                case PageRoutes.outmesasroutes:
                  {
                    return MaterialPageRoute(
                      builder: (context) => BlocProvider<OutZonasCubit>(
                          create: (context) =>
                              OutZonasCubit(context.read<ComandasManager>()),
                          child: const OutZonas()),
                    );
                  }
                case PageRoutes.incomanda:
                  {
                    return MaterialPageRoute(
                      builder: (context) {
                        final Map<String, dynamic> parameters =
                            setting.arguments as Map<String, dynamic>;
                        return BlocProvider<InComandaCubit>(
                            create: (context) => InComandaCubit(
                                context.read<ComandasManager>(),
                                context.read<ClientesManager>()),
                            child: InComandaPortrait(
                              mesa: parameters['mesa'],
                              documento: parameters['documento'],
                            ));
                      },
                    );
                  }
                default:
                  {
                    return null;
                  }
              }
            },
          ),
        ),
      ),
    );
  }
}
