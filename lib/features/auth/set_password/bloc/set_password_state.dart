import 'package:equatable/equatable.dart';

abstract class SetPasswordState extends Equatable {
  const SetPasswordState();

  @override
  List<Object> get props => [];
}

class SetPasswordInitial extends SetPasswordState {}

class SetPasswordLoading extends SetPasswordState {}

class SetPasswordSuccess extends SetPasswordState {
  final String message;

  const SetPasswordSuccess({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class SetPasswordFailure extends SetPasswordState {
  final String error;

  const SetPasswordFailure({required this.error});

  @override
  List<Object> get props => [error];
} 