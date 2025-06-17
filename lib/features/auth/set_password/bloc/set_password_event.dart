import 'package:equatable/equatable.dart';

abstract class SetPasswordEvent extends Equatable {
  const SetPasswordEvent();

  @override
  List<Object> get props => [];
}

class SetPasswordSubmitted extends SetPasswordEvent {
  const SetPasswordSubmitted({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}
