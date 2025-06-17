import 'package:equatable/equatable.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class RegisterFailure extends RegisterState {
  const RegisterFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}
