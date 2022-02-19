part of 'app_state_manager_cubit.dart';

abstract class AppStateManagerState extends Equatable {
  const AppStateManagerState();

  @override
  List<Object> get props => [];
}

class AppStateManagerInitial extends AppStateManagerState {}

class AppStateManagerUnConfigured extends AppStateManagerState {}

class AppStateManagerSerialNotRegistred extends AppStateManagerState {}

class AppStateManagerloading extends AppStateManagerState {
  final String message;

  const AppStateManagerloading(this.message);
  @override
  List<Object> get props => [message];
}

class AppStateManagerError extends AppStateManagerState {
  final String message;

  const AppStateManagerError(this.message);
  @override
  List<Object> get props => [message];
}

class AppStateManagerInitialized extends AppStateManagerState {}
