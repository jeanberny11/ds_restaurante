part of 'out_mesas_cubit.dart';

abstract class OutMesasState extends Equatable {
  const OutMesasState();

  @override
  List<Object> get props => [];
}

class OutMesasInitial extends OutMesasState {
  final List<Mesa> mesas;

  const OutMesasInitial(this.mesas);

  @override
  List<Object> get props => [mesas];
}

class OutMesasLoading extends OutMesasState {}

class OutMesasError extends OutMesasState {
  final String message;

  const OutMesasError(this.message);

  @override
  List<Object> get props => [message];
}
