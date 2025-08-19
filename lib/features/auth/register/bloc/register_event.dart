import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterSubmitted extends RegisterEvent {
  const RegisterSubmitted({
    required this.fullName,
    required this.companyName,
    required this.email,
    required this.password,
  });
  final String fullName;
  final String companyName;
  final String email;
  final String password;

  @override
  List<Object> get props => [fullName, companyName, email, password];
}
