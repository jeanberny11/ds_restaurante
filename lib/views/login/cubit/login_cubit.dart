import 'package:bloc/bloc.dart';
import 'package:ds_restaurante/app_data.dart';
import 'package:ds_restaurante/data/models/usuario.dart';
import 'package:ds_restaurante/managers/usuario_manager.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UsuarioManager _manager;
  LoginCubit(this._manager) : super(LoginInitial());

  Future<void> authUsuario(int clave) async {
    emit(LoginLoading());
    try {
      final usuario = await _manager.authUsuario(clave);
      if (usuario == null) {
        emit(const LoginError('Usuario no Encontrado...'));
        return;
      }
      if (!usuario.f_activo!) {
        emit(const LoginError('Su cuenta de Usuario esta Desactivada...!'));
        return;
      }
      final vendedor = await _manager.getVendedorById(usuario.f_vendedor);
      if (vendedor == null) {
        emit(const LoginError('Este usuario no tiene camarero asignado'));
        return;
      }
      AppData().currentUsuario = usuario;
      AppData().currentVendedor = vendedor;
      emit(LoginDone(usuario));
    } catch (ex) {
      emit(LoginError(ex.toString()));
    }
  }

  void reset() {
    emit(LoginInitial());
  }
}
