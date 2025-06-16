import 'package:equatable/equatable.dart';

abstract class SetPasswordEvent extends Equatable {
  const SetPasswordEvent();

  @override
  List<Object> get props => [];
}

class SetPasswordSubmitted extends SetPasswordEvent {
  final String email;
  final String password;

  const SetPasswordSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
} 