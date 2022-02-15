import 'package:bloc/bloc.dart';
import 'package:ds_restaurante/data/models/mesa_ocupada.dart';
import 'package:ds_restaurante/data/models/mesas.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:equatable/equatable.dart';

part 'out_mesas_state.dart';

class OutMesasCubit extends Cubit<OutMesasState> {
  final ComandasManager _manager;
  OutMesasCubit(this._manager) : super(const OutMesasInitial([]));

  Future<void> loadMesas(int zonaid) async {
    emit(OutMesasLoading());
    try {
      final mesas = await _manager.getMesasZona(zonaid);
      emit(OutMesasInitial(mesas));
    } catch (ex) {
      emit(OutMesasError(ex.toString()));
    }
  }

  Future<List<MesaOcupada>> get getMesasOcupadas => _manager.getMesasOcupadas();
}
