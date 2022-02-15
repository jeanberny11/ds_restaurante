part of 'out_zonas_cubit.dart';

abstract class OutZonasState extends Equatable {
  const OutZonasState();

  @override
  List<Object> get props => [];
}

class OutZonasInitial extends OutZonasState {
  final List<Zona> zonas;

  const OutZonasInitial(this.zonas);

  @override
  List<Object> get props => [zonas];
}

class OutZonasError extends OutZonasState {
  final String message;

  const OutZonasError(this.message);

  @override
  List<Object> get props => [message];
}

class OutZonasLoading extends OutZonasState {}
