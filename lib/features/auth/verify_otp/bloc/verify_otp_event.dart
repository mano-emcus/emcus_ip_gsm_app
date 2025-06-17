import 'package:equatable/equatable.dart';

abstract class VerifyOtpEvent extends Equatable {
  const VerifyOtpEvent();

  @override
  List<Object> get props => [];
}

class VerifyOtpSubmitted extends VerifyOtpEvent {
  const VerifyOtpSubmitted({
    required this.email,
    required this.confirmationCode,
  });
  final String email;
  final String confirmationCode;

  @override
  List<Object> get props => [email, confirmationCode];
}
