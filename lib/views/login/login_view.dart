import 'package:ds_restaurante/utils/app_utils.dart';
import 'package:ds_restaurante/utils/page_routes.dart';
import 'package:ds_restaurante/views/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _claveController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Camarero'),
        centerTitle: true,
      ),
      body: BlocConsumer<LoginCubit, LoginState>(builder: (context, state) {
        if (state is LoginError) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.oswald(color: Colors.red),
                ),
                TextButton(
                    onPressed: () {
                      context.read<LoginCubit>().reset();
                    },
                    child: const Text('Aceptar'))
              ],
            ),
          );
        } else {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('resources/dreamsoftlogo.png'),
                  const SizedBox(
                    height: 30.0,
                  ),
                  const Text('Digite su clave'),
                  TextField(
                    controller: _claveController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    enabled: state is LoginInitial,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  if (state is LoginLoading)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [CircularProgressIndicator.adaptive()],
                    )
                  else
                    ElevatedButton(
                        onPressed: () {
                          if (_claveController.text.isEmpty) {
                            mensaje(context, 'Debe digitar una clave');
                            return;
                          }
                          context
                              .read<LoginCubit>()
                              .authUsuario(int.parse(_claveController.text));
                        },
                        child: const Text('  Entrar  '))
                ],
              ),
            ),
          );
        }
      }, listener: (context, state) {
        if (state is LoginDone) {
          Navigator.of(context).pushReplacementNamed(PageRoutes.outmesasroutes);
        }
      }),
    );
  }
}
