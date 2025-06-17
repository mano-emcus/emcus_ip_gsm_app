import 'package:equatable/equatable.dart';

abstract class SetPasswordState extends Equatable {
  const SetPasswordState();

  @override
  List<Object> get props => [];
}

class SetPasswordInitial extends SetPasswordState {}

class SetPasswordLoading extends SetPasswordState {}

class SetPasswordSuccess extends SetPasswordState {

  const SetPasswordSuccess({
    required this.message,
  });
  final String message;

  @override
  List<Object> get props => [message];
}

class SetPasswordFailure extends SetPasswordState {

  const SetPasswordFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
} 