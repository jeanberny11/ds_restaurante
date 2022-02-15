import 'package:bloc/bloc.dart';
import 'package:ds_restaurante/data/models/zonas_mesas.dart';
import 'package:ds_restaurante/managers/comandas_manager.dart';
import 'package:equatable/equatable.dart';

part 'out_zonas_state.dart';

class OutZonasCubit extends Cubit<OutZonasState> {
  final ComandasManager _manager;
  OutZonasCubit(this._manager) : super(const OutZonasInitial([])) {
    loadZonas();
  }

  Future<void> loadZonas() async {
    emit(OutZonasLoading());
    try {
      final zonas = await _manager.getAllZonas();
      emit(OutZonasInitial(zonas));
    } catch (ex) {
      emit(OutZonasError(ex.toString()));
    }
  }
}
