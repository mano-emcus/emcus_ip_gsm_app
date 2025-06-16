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
  });
  final String fullName;
  final String companyName;
  final String email;

  @override
  List<Object> get props => [fullName, companyName, email];
} 