import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  final String email;
  final String confirmationCode;

  const VerifyOtpSubmitted({
    required this.email,
    required this.confirmationCode,
  });

  @override
  List<Object> get props => [email, confirmationCode];
} 